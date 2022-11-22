import numpy as np
from keras.datasets import mnist
import sys
np.set_printoptions(threshold=sys.maxsize)


MAX_N = 8

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
    # img_vector = np.load('test_img.npy') # Img is a '5'

    (train_images, train_labels), (test_images, test_labels) = mnist.load_data()

    # Vectorize the image
    img_vector = test_images[0].flatten()

    # Convert to Signed 
    img_vector = img_vector.astype(np.float64) - 128.0
    img_vector = img_vector.astype(np.int8)

    # fc1 = np.load('fc1.npy')
    # fc2 = np.load('fc2.npy')
    fc_new = np.load('fc_new.npy')
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
    # img_vector_int = img_vector_int - 128
    # print("Signed Input:", img_vector_signed, "\n")
    print("Input Vector:")
    print(img_vector)
    print()
    res = fc_new.dot(img_vector)
    # res = np.matmul(img_vector, fc_new.T)
    # res = np.tensordot(img_vector, fc_new, 1)
    print("FC1 Res:", res, "\n")

    '''
    res = sigmoid(res)
    print("Sigmoid Res:", res, "\n")
    
    res = fc2.dot(res)
    print("FC2 Res:", res, "\n")
    '''

    res = softmax_stable(res)
    print("Softmax Res:", res, "\n")
    print("Expected: ", test_labels[0])
    # [[ 31 -45  37  78  21  45 -36 109  50  64]] vs [  17  -17  107   32  -73 -102  119   -4  111  -68] 
