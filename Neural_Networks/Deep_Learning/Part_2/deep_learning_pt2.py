#__________________________________________________________________________
# ΥΠΟΛΟΓΙΣΤΙΚΗ ΝΟΥΜΟΣΥΝΗ - ΣΥΣΤΗΜΑΤΑ ΕΜΠΝΕΥΣΜΕΝΑ ΑΠΟ ΤΗ ΒΙΟΛΟΓΙΑ
# ΕΡΓΑΣΙΑ 2η - Μέρος Δεύτερο
# Όνομα : Παυσανίας Κακαρίνος  AM :387 e-mail : pafsanias@gmail.com
# Όνομα : Ιωάννης Κατσικαβέλας ΑΜ :361 e-mail : ioankats93@gmail.com
#__________________________________________________________________________

from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense
from keras import backend as K
from keras.utils import plot_model
import matplotlib.pyplot as plt
import numpy

# dimensions of our images.
img_width, img_height = 224, 224

train_data_dir = "/home/ioannis/Desktop/clsimage/train"
validation_data_dir = "/home/ioannis/Desktop/clsimage/validation"
nb_train_samples = 1919
nb_validation_samples = 1157
epochs = 100
batch_size = 32

if K.image_data_format() == 'channels_first':
    input_shape = (3, img_width, img_height)
else:
    input_shape = (img_width, img_height, 3)

model = Sequential()
model.add(Conv2D(32, (3, 3), input_shape=input_shape))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(64, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Flatten())
model.add(Dense(128))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(3))
model.add(Activation('sigmoid'))

model.compile(loss='categorical_crossentropy',
              optimizer='rmsprop',
              metrics=['accuracy'])

# this is the augmentation configuration we will use for training
train_datagen = ImageDataGenerator(
    #rotation_range =10
    #vertical_flip = True
    rescale=1. / 255,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True)

# this is the augmentation configuration we will use for testing:
# only rescaling
test_datagen = ImageDataGenerator(rescale=1. / 255)

train_generator = train_datagen.flow_from_directory(
    train_data_dir,
    target_size=(img_width, img_height),
    batch_size=batch_size,
    shuffle="true",
    class_mode='categorical')

validation_generator = test_datagen.flow_from_directory(
    validation_data_dir,
    target_size=(img_width, img_height),
    batch_size=batch_size,
    class_mode='categorical')

history = model.fit_generator(
    train_generator,
    steps_per_epoch=nb_train_samples//batch_size,
    epochs=epochs,
    validation_data=validation_generator,
    validation_steps=nb_validation_samples//batch_size)

#serialize model to JSON
model_json = model.to_json()
with open("model_l2.json", "w") as json_file:
    json_file.write(model_json)
#Serialize weights to HDF5
model.save_weights('model_l2.h5')
print("Model saved successfully to the disk!\n")

# list all data in history
print(history.history.keys())
plt.plot(history.history['acc'])
plt.plot(history.history['val_acc'])
plt.title('Model accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.legend(['train', 'validation'], loc='upper left')
plt.show()

plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('Model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'validation'], loc='upper right')
plt.show()

plot_model(model, to_file='model_l2.png')
