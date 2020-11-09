# File:		BlackPearl_Algorithm.py
# Author: 	Lei Kuang
# Date:		8th August 2020
# @ Imperial College London

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

def non_local_mean_filtering(img):
    dst = cv.fastNlMeansDenoisingColored(img, None, 30, 7, 21)
    
if __name__ == '__main__':
    img = cv.imread('demo.png')
    dst = cv.fastNlMeansDenoisingColored(img, None, 100.0, 7, 21)
    plt.subplot(121),plt.imshow(img)
    plt.subplot(122),plt.imshow(dst)
    plt.show()
