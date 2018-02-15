import os, sys
from os import listdir
from os.path import isfile, join
from random import shuffle
import numpy as np
import shutil
from sklearn.cross_validation import train_test_split
from keras.preprocessing.image import ImageDataGenerator, array_to_img, img_to_array, load_img

# Set classes path for image extraction
bird = "/home/ioannis/Desktop/VOCdevkit/VOC2012/ImageSets/Main/bird_trainval.txt"
cat = "/home/ioannis/Desktop/VOCdevkit/VOC2012/ImageSets/Main/cat_trainval.txt"
random = "/home/ioannis/Desktop/VOCdevkit/VOC2012/ImageSets/Main/"
ourClasses = [bird, cat]
images = [[],[]]
X = [[],[],[]]
Y = [[],[],[]]
path = "/home/ioannis/Desktop/clsimage"
pathtrain = "/home/ioannis/Desktop/clsimage/train"
pathval = "/home/ioannis/Desktop/clsimage/validation"

train = ["/home/ioannis/Desktop/clsimage/train/birds",
         "/home/ioannis/Desktop/clsimage/train/cats",
         "/home/ioannis/Desktop/clsimage/train/random"]

val = ["/home/ioannis/Desktop/clsimage/validation/birds",
       "/home/ioannis/Desktop/clsimage/validation/cats",
       "/home/ioannis/Desktop/clsimage/validation/random"]

seed = 1312

# create folder with training images
def mkdir(path):
    if not os.path.exists(path):
        print("Making dir {} ".format(path))
        os.makedirs(path)
    if not os.path.exists(pathtrain):
        print("Making dir {} ".format(pathtrain))
        os.makedirs(pathtrain)
    if not os.path.exists(pathval):
        print("Making dir {} ".format(pathval))
        os.makedirs(pathval)
    for i in range(3):
        if not os.path.exists(train[i]):
            print("Making dir {} ".format(train[i]))
            os.makedirs(train[i])
        if not os.path.exists(val[i]):
            print("Making dir {} ".format(val[i]))
            os.makedirs(val[i])
mkdir(path)
print("\n")
for i in range(2):
    print("Searching ", ourClasses[i][54:], "file for images...")
    with open(ourClasses[i], 'r') as f:
        for line in f:
            str = line[12]
            if str != '-':
                str = line[0:11]
                str = str +'.jpg'
                images[i].append(str)
    #random.seed(1234)
    a,b = train_test_split(images[i],test_size=0.3)
    for k in range(len(a)):
        X[i].append(a[k])
    for l in range(len(b)):
        Y[i].append(b[l])
print("\n")

# Take random images from all the other classes
sumRanImages = []
allImages =  len(images[0]) + len(images[1])
while len(sumRanImages) < (allImages / 2):
    for filename in os.listdir(random):
        if filename.endswith("trainval.txt"):
            if filename != 'bird_trainval.txt' and filename != 'cat_trainval.txt'  and filename != 'trainval.txt' and len(sumRanImages) < (allImages / 2)  :
                #sys.stdout.write("\rGetting images for random class from " + filename)
                #sys.stdout.flush()
                #print(filename)
                with open(random + filename, 'r') as rf:
                    classSum = 0
                    for line in rf:
                        if classSum <= 15 and len(sumRanImages) < (allImages / 2):
                            str = line[12]
                            if str != '-':
                                str = line[0:11]
                                str = str +'.jpg'
                                sumRanImages.append(str)
                                classSum += 1
                    print("Filename ", filename, len(sumRanImages))
np.random.seed(seed)
shuffle(sumRanImages)
a,b = train_test_split(sumRanImages,test_size=0.3)
for k in range(len(a)):
    X[2].append(a[k])
for l in range(len(b)):
    Y[2].append(b[l])


os.chdir("/home/ioannis/Desktop/VOCdevkit/VOC2012/JPEGImages/")
for j in range(3):
    for f in X[j]:
        sys.stdout.write("\rCopying " + f)
        sys.stdout.flush()
        shutil.copy(f, train[j])

    for g in Y[j]:
        sys.stdout.write("\rCopying " + g)
        sys.stdout.flush()
        shutil.copy(g, val[j])

print("\n######################################################")
print("Sum of train_bird ", len(X[0]))
print("Sum of train_cat ", len(X[1]))
print("Sum of train_random ", len(X[2]))
print("Sum of val_bird ", len(Y[0]))
print("Sum of val_cat ", len(Y[1]))
print("Sum of val_random ", len(Y[2]))
print("\nSum of all images ", len(images[0]) + len(images[1]) + len(sumRanImages))

os.chdir("/home/ioannis/Desktop/clsimage/train/")
