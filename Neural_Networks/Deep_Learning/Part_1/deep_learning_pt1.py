#__________________________________________________________________________
# ΥΠΟΛΟΓΙΣΤΙΚΗ ΝΟΥΜΟΣΥΝΗ - ΣΥΣΤΗΜΑΤΑ ΕΜΠΝΕΥΣΜΕΝΑ ΑΠΟ ΤΗ ΒΙΟΛΟΓΙΑ
# ΕΡΓΑΣΙΑ 2η - Μέρος Πρώτο
# Όνομα : Παυσανίας Κακαρίνος  AM :387 e-mail : pafsanias@gmail.com
# Όνομα : Ιωάννης Κατσικαβέλας ΑΜ :631 e-mail : ioankats93@gmail.com
#__________________________________________________________________________

from keras.applications import VGG16
from keras.applications import imagenet_utils
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import load_img
import numpy as np
import argparse, cv2, os

for files in os.listdir("classification_images"):
	print("#######################################")
	print (files,"\n")

	# initialize the input image shape (224x224 pixels) along with
	# the pre-processing function
	inputShape = (224, 224)
	preprocess = imagenet_utils.preprocess_input

	# load our the network weights from disk (NOTE: if this is the
	# first time you are running this script for a given network, the
	# weights will need to be downloaded first so be
	# patient; the weights will be cached and subsequent runs of this
	# script will be *much* faster)
	print("[INFO] loading vgg16...")
	Network = VGG16
	model = Network(weights="imagenet")

	# load the input image using the Keras helper utility while ensuring
	# the image is resized to `inputShape`, the required input dimensions
	# for the ImageNet pre-trained network
	print("[INFO] loading and pre-processing image...")
	image = load_img("classification_images/{}".format(files), target_size=inputShape)
	image = img_to_array(image)

	# our input image is now represented as a NumPy array of shape
	# (inputShape[0], inputShape[1], 3) however we need to expand the
	# dimension by making the shape (1, inputShape[0], inputShape[1], 3)
	# so we can pass it through thenetwork
	image = np.expand_dims(image, axis=0)

	# pre-process the image using the appropriate function based on the
	# model that has been loaded (i.e., mean subtraction, scaling, etc.)
	image = preprocess(image)

	# classify the image
	print("[INFO] classifying image with 'vgg16'...")
	preds = model.predict(image)
	P = imagenet_utils.decode_predictions(preds)

	# loop over the predictions and display the rank-5 predictions +
	# probabilities to our terminal
	for (i, (imagenetID, label, prob)) in enumerate(P[0]):
		print("{}. {}: {:.2f}%".format(i + 1, label, prob * 100))
	# load the image via OpenCV, draw the top prediction on the image,
	# and display the image to our screen
	orig = cv2.imread("classification_images/{}".format(files))
	(imagenetID, label, prob) = P[0][0]
	cv2.putText(orig, "Label: {}, {:.2f}%".format(label, prob * 100),
		(10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 255), 2)
	cv2.imshow("Classification", orig)
	print("[INFO] Press 'q' to continue : \n")
	cv2.waitKey(0)
