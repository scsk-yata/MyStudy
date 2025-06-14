# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt
import sklearn.neural_network
import sklearn.datasets
import sklearn.metrics

digits = sklearn.datasets.load_digits()
data_train  = digits['data'][:1600]
data_test   = digits['data'][1600:]
label_train = digits['target'][:1600]
label_test  = digits['target'][1600:]

model = sklearn.neural_network.MLPClassifier(
    activation='relu',
    solver='lbfgs',
    hidden_layer_sizes=(1024, 512, 256, 128 ),
    max_iter=100,
)
model.fit( data_train, label_train )
label_pred = model.predict( data_test )
print( sklearn.metrics.confusion_matrix( label_test, label_pred ) )

num=0
plt.subplots_adjust( wspace=0.4, hspace=0.6 )
for k in range( len( label_test) ):
   if label_test[k] != label_pred[k]:
      num = num + 1
      if num < 21:
         plt.subplot( 4, 5, num )
         plt.imshow( digits['images'][1600+k], cmap='gray_r', interpolation='None')
         plt.axis('off')
         plt.title('Pred:%d(%d)' % (label_test[k], label_pred[k]) )
plt.show()
