import numpy as np
import time
import pathlib
import tensorflow as tf
from numpy.random import default_rng
import matplotlib.pyplot as plt
from keras.layers import Dense, Flatten, Normalization
from keras.models import Sequential
from keras.utils import to_categorical
from keras.datasets import mnist

import tensorflow_model_optimization as tfmot
import tensorflow as tf

# Load MNIST dataset
(train_images, train_labels), (test_images, test_labels) = mnist.load_data()

# Normalize the input image so that each pixel value is between 0 to 1.
train_images = train_images / 255.0
test_images = test_images / 255.0

# Create simple Neural Network model
model = Sequential()
model.add(Flatten(input_shape=(28, 28)))
# model.add(Normalization(axis=1))
# model.add(Resizing(8, 8, interpolation="bilinear", crop_to_aspect_ratio=False))
# model.add(Dense(8, activation='sigmoid', use_bias=False))
# model.add(Dense(8, activation='sigmoid', use_bias=False))
model.add(Dense(10, activation='softmax', use_bias=False))
model.summary()

# Train the digit classification model
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

model.fit(
    train_images,
    train_labels,
    epochs=10,
    validation_data=(test_images, test_labels)
)

score = model.evaluate(test_images, test_labels)
print("Test loss {:.4f}, accuracy {:.2f}%".format(score[0], score[1] * 100))
time.sleep(5)

'''
weights = model.get_weights()

for layer in model.layers:
    weights = layer.get_weights() # list of numpy arrays
    print(len(weights))

    # np.save('test_img.npy', X_train[0].flatten())

    for weight_dim in weights:
        print(weight_dim.shape)
        print(weight_dim)
        print()
    
    print("-------------------------------------------------------------")


predictions = model.predict(X_test)
predictions = np.argmax(predictions, axis=1)
fig, axes = plt.subplots(ncols=10, sharex=False, sharey=True, figsize=(20, 4))

for i in range(10):
    axes[i].set_title(predictions[i])
    axes[i].imshow(X_test[i], cmap='gray')
    axes[i].get_xaxis().set_visible(False)
    axes[i].get_yaxis().set_visible(False)

plt.show()


for layer in model.layers:
    weights = layer.get_weights() # list of numpy arrays
    for weight_dim in weights:
        print(weight_dim.shape)
        print(weight_dim)
        print()
    print("-------------------------------------------------------------")
'''

'''
quantize_model = tfmot.quantization.keras.quantize_model

# q_aware stands for for quantization aware.
q_aware_model = quantize_model(model)

# `quantize_model` requires a recompile.
q_aware_model.compile(optimizer='adam',
                      loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
                      metrics=['accuracy'])

q_aware_model.summary()
'''

# converter = tf.lite.TFLiteConverter.from_keras_model(q_aware_model)
converter = tf.lite.TFLiteConverter.from_keras_model(model)

mnist_train, _ = tf.keras.datasets.mnist.load_data()
images = tf.cast(mnist_train[0], tf.float32) / 255.0
mnist_ds = tf.data.Dataset.from_tensor_slices((images)).batch(1)

def representative_data_gen():
  for input_value in mnist_ds.take(100):
    yield [input_value]

converter.representative_dataset = representative_data_gen
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
converter.inference_input_type = tf.int8
converter.inference_output_type = tf.int8

'''
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
converter.representative_dataset = representative_data_gen
converter.inference_input_type = tf.uint8
converter.inference_output_type = tf.uint8
converter.exclude_conversion_metadata = False
'''

tflite_model_quant = converter.convert()

tflite_models_dir = pathlib.Path.cwd()
# tflite_models_dir.mkdir(exist_ok=True, parents=True)
tflite_model_quant_file = tflite_models_dir/"new_model.tflite"
tflite_model_quant_file.write_bytes(tflite_model_quant)



"""
interpreter = tf.lite.Interpreter(model_content=quantized_tflite_model)
signatures = interpreter.get_signature_list()
print("signatures:")
print(signatures, "\n")

open("mnist_tfquant.tflite", "wb").write(quantized_tflite_model)

print(len(quantized_tflite_model))
print(type((quantized_tflite_model)))

input_type = interpreter.get_input_details()[0]['dtype']
print('input: ', input_type)
output_type = interpreter.get_output_details()[0]['dtype']
print('output: ', output_type)


for layer in quantized_tflite_model.layers:
    weights = layer.get_weights() # list of numpy arrays

    print(len(weights))
    print(weights.shape)
    # np.save('test_img.npy', X_train[0].flatten())

    for weight_dim in weights:
        print(weight_dim.shape)
        print(weight_dim)
        print()

    print("-------------------------------------------------------------")

"""