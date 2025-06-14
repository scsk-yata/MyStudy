# -*- coding: utf-8 -*- 
import matplotlib.pyplot as plt
import sklearn.datasets # scikit-learn の datasets の利用

digits = sklearn.datasets.load_digits() # 手書き数字文字

# 手書き文字の表示
for k in range(400):
    plt.subplot( 20, 20, k+1 )
    plt.imshow( digits['images'][k], cmap='gray_r', interpolation='None' )
    plt.axis('off')
plt.show()

data_train  = digits['data'][:1600]
data_test   = digits['data'][1600:]
label_train = digits['target'][:1600]
label_test  = digits['target'][1600:]	
