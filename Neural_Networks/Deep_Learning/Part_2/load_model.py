from keras.models import load_model
from keras.models import model_from_json
from keras.applications import imagenet_utils
from keras.preprocessing.image import img_to_array
from sklearn.preprocessing import scale
import os, sys
import numpy as np
from keras.models import load_model
from keras.preprocessing import image
from keras.applications import imagenet_utils

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
# dimensions of our images
img_width, img_height = 224, 224
catsPredicted, birdsPredicted, NothingPredicted = 0, 0, 0
folder =['/home/ioannis/Desktop/foto/cats',
         '/home/ioannis/Desktop/foto/birds',
         '/home/ioannis/Desktop/foto/nothing']



#load the model we created
json_file = open('/home/ioannis/Desktop/model_l2.json', 'r')
loaded_model_json = json_file.read()
json_file.close()
loaded_model = model_from_json(loaded_model_json)
# load weight into model
loaded_model.load_weights("/home/ioannis/Desktop/model_l2.h5")
print("\nModel successfully loaded from disk! ")

#print model summary
print(loaded_model.summary())

#Predict image
def predict_image(image):
    img =image.load_img(image, target_size=(224, 224))
    img = np.asarray(img,'float32')/255.0
    image = np.expand_dims(img, axis = 0)
    preds = loaded_model.predict(image)
    print("\rImage is : " + image)
    #pred_classes = np.argmax(preds)
    print(preds)
    print(pred_classes)

for subfolder in folder :
    catsPredicted, birdsPredicted, NothingPredicted = 0, 0, 0
    print("\nPredicting",subfolder , "images")
    for filename in os.listdir(subfolder):
        #print(filename)
        x = subfolder +'/'+filename
        img =image.load_img(x, target_size=(224, 224))
        img1 = np.asarray(img,'float32')/255.0
        image2 = np.expand_dims(img1, axis = 0)
        preds = loaded_model.predict(image2)
        birdsPredicted +=preds[0,0]
        catsPredicted += preds[0,1]
        NothingPredicted += preds[0,2]
    catmeans = catsPredicted /50
    birdsmean = birdsPredicted /50
    nothingmean = NothingPredicted /50
    allmeans = [round(catmeans, 2) , round(birdsmean, 2), round(nothingmean, 2)]
    print(' Cat | Bird | Nothing')
    print(allmeans)
