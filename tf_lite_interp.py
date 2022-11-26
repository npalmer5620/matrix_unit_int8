import tensorflow as tf
from keras.datasets import mnist
import matplotlib.pylab as plt
import numpy as np
from random import randrange
import sys
np.set_printoptions(threshold=sys.maxsize)

# N = randrange(10000)
N = 0
(train_images, train_labels), (test_images, test_labels) = mnist.load_data()


interpreter_quant = tf.lite.Interpreter(model_path='new_model.tflite')
interpreter_quant.allocate_tensors()

input_details = interpreter_quant.get_input_details()
output_details = interpreter_quant.get_output_details()

input_index_quant = input_details[0]["index"]
output_index_quant = output_details[0]["index"]


print("== Input details ==")
print("name:", input_details[0]['name'])
print("index:", input_details[0]['index'])
print("shape:", input_details[0]['shape'])
print("type:", input_details[0]['dtype'])

print("\n== Output details ==")
print("name:", output_details[0]['name'])
print("index:", output_details[0]['index'])
print("shape:", output_details[0]['shape'])
print("type:", output_details[0]['dtype'], "\n")


test_image = np.expand_dims(test_images[N], axis=0).astype(np.uint8)
test_image_signed = np.expand_dims(test_images[N], axis=0).astype(np.int8)
test_image_signed_offset = np.expand_dims(test_images[N], axis=0).astype(np.float64) - 128.0
test_image_signed_offset = test_image_signed_offset.astype(np.int8)

# For unsgined change to : interpreter_quant.set_tensor(input_index_quant, test_image)
interpreter_quant.set_tensor(input_index_quant, test_image_signed_offset)
interpreter_quant.invoke()

print("====================")
for n in range(6):
    layer = interpreter_quant.get_tensor(n)
    print(str(n)+": ", layer.shape, layer.dtype)
    print(layer)
    print("====================")

predictions = interpreter_quant.get_tensor(output_index_quant)

print("\nExpected: ", test_labels[N])
print("Raw Output: ", predictions[0])
print("Most Probable: ", predictions.argmax(axis=1)[0], ":", (predictions[0][predictions.argmax(axis=1)[0]] / 255.0) * 100.0, "% acc" )

plt.imshow(test_images[N], cmap='gray')
template = "True:{true}, predicted:{predict}, prob:{prob}"
_ = plt.title(template.format(true= str(test_labels[N]),
                              predict=str(np.argmax(predictions[0])),
                              prob=str((predictions[0][predictions.argmax(axis=1)[0]] / 255.0) * 100.0) + "%"))
plt.grid(False)
# plt.show()


