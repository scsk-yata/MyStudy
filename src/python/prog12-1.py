# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt
import sklearn.datasets
import sklearn.metrics
import tensorflow as tf
import tensorflow.keras.utils
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

np.random.seed( 1 )
data, label=sklearn.datasets.make_moons(n_samples=2000, shuffle=True, noise=0.15, random_state=1 )

data_train  = data[:1600]  # 最初の1600個を学習データ
data_test   = data[1600:]  # 残りのデータを検証用データ
label_train = label[:1600]
label_test  = label[1600:]

model = Sequential([
    Dense( 100, activation='sigmoid', input_shape=( data_train.shape[1],) ),
    Dense(  10, activation='sigmoid' ),
    Dense(   1, activation='sigmoid' ),
])
model.compile( loss='mean_squared_error', optimizer='SGD', metrics=['accuracy'] )
history = model.fit( data_train, label_train, epochs=200, validation_data=(data_test, label_test) )

label_pred = model.predict( data_test )

plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.show()
