'''
Imports the training data, pre-processes it, and puts it in a .csv file for Azure ML
Images must be of the format "struct<moleculeId>_<image#>.png" and be in the path to this script
It also saves all your compressed images as "compressed_struct<moleculeID>_<image#>.png". 

File format for training data:

There must be the same number of training images for each molecule
Change moleculeIds to the list of moleculeIds you have
Change start and end index to the start and end image#'s you have- single digit indices should be "01, 02, 03" etc.
(For example, "struct19_01" to "struct19_40" should be 1, and 41.)
Change nRows and nCols to the amount of data compression you want. This needs to be consistent with the test data's compression scheme.
(I recommend nRows*nCols should be about the number of training examples per molecule)

One example of a training data image is provided in the repository. 
The data we used is provided in a link on the README on the GitHub.

'''

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import time

class labeled_image:
    def __init__(self, array_in, label_in, fname_in):
        self.array = array_in
        self.label = label_in
        self.fname = fname_in

moleculeIds = [19,4,22,5,13,20,16,1,8]
startIdx = 1
endIdx = 41
nRows = 8
nCols = 12

#int to string
def indexToString(idx):
    if idx < 10:
        out = "0" + str(idx)
    else:
        out = str(idx)
    return out
    
#numpy array (x,y,3) to numpy array with (x,y)
def rgbToGrayscale(img):
    red = img[:,:,0]
    green = img[:,:,1]
    blue = img[:,:,2]
    gray = (red + blue + green) / 3 #averages the RGB components
    return gray
    
#numpy array (3264x2448) to numpy array (8x6)
def compress(img, outname="default.npy", rows = 8, cols = 12):
    compressed = np.zeros((rows,cols))
    origrows = img.shape[0]
    origcols = img.shape[1]
    it = np.nditer(img, flags=['multi_index'])
    pixel = 0;
    #pixelDistribution(img)
    while not it.finished:
        xidx = it.multi_index[0]
        yidx = it.multi_index[1]
        new_x = int(np.floor(rows*xidx/origrows))
        new_y = int(np.floor(cols*yidx/origcols))
        compressed[new_x, new_y] += it[0]
        it.iternext()
    np.save(outname, compressed)       
    return compressed

 
#list of ints, filename, start=index of first image, end = index of last image, rows and cols is the compression level
#files should be in format "struct<mol#>_<img_index>.png"
#there must be the same number of images for each molecule
def fillTraining(ids, start, end, rows, cols):
    trainingExamples = []
    nTrainingExamples = 0
    for mol in ids:
        print "Filling for molecule", mol
        for i in range(start,end):
            print "for image", i, "out of 40"
            img = mpimg.imread("struct" + str(mol) + "_" + indexToString(i) + ".png")
            gray = rgbToGrayscale(img)
            compressed = compress(gray, "compressed_struct" + str(mol) + "_" + indexToString(i) + ".npy", rows=rows, cols=cols)
            trainEx = labeled_image(compressed, mol, "compressed_struct" + str(mol) + "_" + indexToString(i) + ".npy")
            trainingExamples.append(trainEx)
            nTrainingExamples += 1
    return trainingExamples, nTrainingExamples

def vectorize(trainEx):
    arr = trainEx.array
    out = np.reshape(arr, -1)
    offset = np.mean(out)
    sd = np.std(out)
    #newarr = np.divide(np.subtract(arr,offset),sd)
    #plt.imshow(newarr, cmap="gray")
    #plt.show()
    return (out-offset)/sd

def vectorizeAll(trainExList):
    vectors = [vectorize(labeled_image) for labeled_image in trainExList]
    return np.asarray(vectors)

def makeLabels(trainExList):
    labels = [labeled_image.label for labeled_image in trainExList]
    return np.asarray(labels)

def makeInput(ids, start, end, rows, cols):
    trainingExamples, nTrainingExamples = fillTraining(ids, start, end, rows, cols)
    X = vectorizeAll(trainingExamples)  
    y = makeLabels(trainingExamples)
    y=y.reshape(nTrainingExamples,1)
    combine = np.concatenate((X,y),axis=1)
    np.savetxt("trainingX.csv", X, delimiter=",")
    np.savetxt("trainingy.csv", y, delimiter=",")
    np.savetxt("trainingBoth.csv", combine, delimiter=",")
    return X, y
    
makeInput(moleculeIds, startIdx, endIdx, nRows, nCols)
