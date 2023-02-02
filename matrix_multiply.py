import numpy as np
from keras.datasets import mnist
import sys
from math import exp

np.set_printoptions(threshold=sys.maxsize)


MAX_N = 8

def softmax_stable(x):
    exp_sum = 0
    for n in x:
        exp_sum = exp_sum + np.exp(n)
    print("exp sum:", exp_sum)
    f = np.exp(x - np.max(x))  # shift values
    print("inter: ", f)
    for n in f:
        print(n)
    print()
    return f / f.sum(axis=0)

def softmax(x):
    print("----- SOFTMAX -----")
    print("Input: ", x)
    print("Vector Exp: ", np.exp(x))
    x = np.exp(x) / np.sum(np.exp(x), axis=0)
    print("Output: ", x)
    print("-------------------")
    return x

def recursive_mm(A:np.ndarray, B:np.ndarray):
    print(A)

if __name__ == "__main__":
    # Load Test Dataset
    (train_images, train_labels), (test_images, test_labels) = mnist.load_data()
    
    # Vectorize (flatten) the image and convert to unsigned values to signed
    N = 2
    img_vector = test_images[N].flatten()
    img_vector = img_vector.astype(np.float64) - 128.0
    img_vector = img_vector.astype(np.int8)
    print("Input Vector:\n", img_vector)


    # Load fully connected layer weights
    fc_new = np.load('fc_new_int.npy')


    # Make weights and inputs 32 bit so no overflow in matrix multiply 
    img_vector = img_vector.astype(np.int32)
    fc_new = fc_new.astype(np.int32)


    # Compute Result
    res = fc_new.dot(img_vector)
    print("FC1 Res:", res, "\n")
    # or: res = np.matmul(img_vector, fc_new.T)
    # or: res = np.tensordot(img_vector, fc_new, 1)


    # Result Quantization
    # The 2 numbers are respective output and weight quantization values which make up the bottom #
    # res = ((res) * 0.13677961678 * 0.002304096706211567) + 1.0
    # This is a division by 3173.057, + 1
    # res = ((res) * 0.00031515346) + 1.0
    res = (res // 3173) + 1
    res = (np.rint(res)).astype(np.int8)
    print("FC1 Scaled Res:", res, "\n")


    # Softmax Calculations
    res = res * 1.0
    res = softmax_stable(res)
    print("Softmax Res:", res, "\n")


    # Results
    print("Predicted: ", res.argmax(), "@", res[res.argmax()])
    print("Expected: ", test_labels[N])

    ''' Exp Calcs
    x_vals = []
    y_vals = []
    for x in range(0, 4+1):
        x_vals.append(x)
        y_vals.append(exp(x))
    
    a, b, c = np.polyfit(x_vals, y_vals, 2)
    print("a: ", a)
    print("b: ", b)
    print("c: ", c)
    '''