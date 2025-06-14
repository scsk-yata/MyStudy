# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt
import sklearn.metrics
import tensorflow as tf
import tensorflow.keras.datasets
import tensorflow.keras.utils
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Reshape 
from tensorflow.keras.layers import Flatten, Conv2D, MaxPooling2D

(data_train, label_train), (data_test, label_test) = tf.keras.datasets.cifar10.load_data()
data_train = data_train.astype( 'float32' ) / 255
data_test  = data_test.astype( 'float32' ) / 255
label_train = label_train.astype( 'int32' )
label_test  = label_test.astype( 'int32' )

label_num = 10
one_hot_train = tf.keras.utils.to_categorical( label_train, label_num )
one_hot_test  = tf.keras.utils.to_categorical( label_test,  label_num )

# ここで CNN を定義する
model = Sequential([
   Conv2D( 32, (3,3), use_bias=True, activation='relu', input_shape=(32,32,3) ),
   MaxPooling2D( (2,2) ),
   Dropout( 0.25 ),
   Conv2D( 64, (3,3), use_bias=True, activation='relu', ),
   MaxPooling2D( (2,2) ),
   Dropout( 0.25 ),
   Conv2D( 128, (3,3), use_bias=True, activation='relu', ),
   MaxPooling2D( (2,2) ),
   Dropout( 0.25 ),
   Flatten(),
   Dense( 64, activation='relu' ),
   Dropout( 0.5 ),
   Dense( label_num, activation='softmax' ),
])

model.compile( loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'] )
history = model.fit( data_train, one_hot_train, epochs=30, batch_size=1000, validation_data=(data_test, one_hot_test) )
label_pred = model.predict( data_test ).argmax( axis=1 )
print( sklearn.metrics.confusion_matrix( label_test, label_pred ) )
