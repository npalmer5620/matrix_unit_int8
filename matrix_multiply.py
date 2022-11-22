import numpy as np

MAX_N = 8

import math

def sigmoid(x):
    print("----- SIGMOID -----")
    ki = 0.0470588244497776
    ko = 1.0
    print("Input: ", x)
    x = ((255.0) / (1.0 + np.exp(-1.0 * ki * x))) + -128.0
    x = (ko * (x))
    x = x.astype("int8")
    print("Output: ", x)
    print("-------------------")
    return x

def softmax(x):
    print("----- SOFTMAX -----")
    print("Input: ", x)
    x = np.exp(x) / np.sum(np.exp(x), axis=0)
    print("Output: ", x)
    print("-------------------")
    return x

# https://stackoverflow.com/questions/10871220/making-a-matrix-square-and-padding-it-with-desired-value-in-numpy
def squarify(M,val):
    (a,b)=M.shape
    if a>b:
        padding=((0,0),(0,a-b))
    else:
        padding=((0,b-a),(0,0))
    return np.pad(M,padding,mode='constant',constant_values=val)


def recursive_mm(A:np.ndarray, B:np.ndarray):
    print(A)


if __name__ == "__main__":
    img_vector = np.load('test_img.npy') # Img is a '5'
    # print(img_vector, "\n")
    # print(img_vector[0])
    # print(img_vector_int, "\n")
    # print(img_vector_int[0])

    fc1 = np.load('fc1.npy')
    fc2 = np.load('fc2.npy')
    # print(fc1.dtype)
    # print(fc2)

    # img_vector = np.array([img_vector])
    # print(img_vector.shape)
    """
    img_mtx_padded = squarify(img_vector, 0)
    print(img_mtx_padded.shape)
    print(img_mtx_padded[0])
    print(img_mtx_padded)
    """
    # print("Unsigned Input:", img_vector, "\n")

    img_vector_signed = img_vector.astype("int8")
    # img_vector_int = img_vector_int - 128
    # print("Signed Input:", img_vector_signed, "\n")

    res = fc1.dot(img_vector_signed)
    print("FC1 Res:", res, "\n")

    res = sigmoid(res)
    print("Sigmoid Res:", res, "\n")

    res = fc2.dot(res)
    print("FC2 Res:", res, "\n")

    res = softmax(res)
    print("Softmax Res:", res, "\n")
