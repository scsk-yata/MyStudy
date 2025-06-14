# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt
import sklearn.datasets
import sklearn.metrics
import tensorflow as tf
import tensorflow.keras.utils
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Reshape
from tensorflow.keras.layers import Flatten, Conv2D, MaxPooling2D

digits = sklearn.datasets.load_digits() # 手書き文字データ
data_train  = digits['data'][:1600]   # 訓練用データ
data_test   = digits['data'][1600:]   # 検証用データ
label_train = digits['target'][:1600] # 訓練用ラベル
label_test  = digits['target'][1600:] # 検証用ラベル

label_num = label_train.max().astype( np.int16 ) + 1
one_hot_train = tf.keras.utils.to_categorical( label_train, label_num )
one_hot_test  = tf.keras.utils.to_categorical( label_test,  label_num )

model = Sequential([
    Reshape( (8,8,1), input_shape=(64,) ),
    Conv2D( 64, (3,3), padding='same', use_bias=True ),
    Conv2D( 128, (3,3), padding='same', use_bias=True ),
    MaxPooling2D( (2,2) ),
    Flatten(), 
    Dense( 128, activation='relu' ),
    Dropout( 0.5 ),
    Dense( label_num, activation='softmax' ),
])
model.compile( loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'] )
history = model.fit( data_train, one_hot_train, batch_size=40, epochs=200, validation_data=(data_test, one_hot_test) )

label_pred = model.predict( data_test )
print( sklearn.metrics.confusion_matrix( label_test, np.argmax( label_pred, axis=1 ) ) )

plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.show()
