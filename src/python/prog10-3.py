# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt
import sklearn.neural_network
import sklearn.datasets
import mlxtend.plotting

np.random.seed( 1 )
data, label=sklearn.datasets.make_moons(n_samples=200, shuffle=True, noise=0.15, random_state=1 )
A = np.array([[10.0*np.cos(np.pi/3), np.sin(np.pi/3)],[-10.0*np.sin(np.pi/3), np.cos(np.pi/3)]])
data = np.dot( data, A ) + [10.0, -5.0]
label = np.array([ -1 if k==0 else 1 for k in label ])

model = sklearn.neural_network.MLPClassifier(
    activation='tanh',       # tanh関数
    solver='lbfgs',          # Limited memory BFGS法 で重み更新
    hidden_layer_sizes=(3,), # 中間層 ニューロン数 3（これを変化させる）
    max_iter = 1000,         # 学習の最大反復回数 1000
)

model.fit( data, label )
mlxtend.plotting.plot_decision_regions( data, label, model )
plt.show()
