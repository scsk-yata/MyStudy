# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt
import sklearn.neural_network
import sklearn.datasets
import mlxtend.plotting

np.random.seed( 1 )
data, label=sklearn.datasets.make_moons(n_samples=200, shuffle=True, noise=0.15, random_state=1 )

model = sklearn.neural_network.MLPClassifier(
	activation='relu',          # ReLU関数
	solver='lbfgs',             # Limited memory BFGS法 で重み更新
	# 隠れ層数3 各層ニューロン数 8, 8, 8
	hidden_layer_sizes=(8, 8, 8, ), 
	max_iter = 1000,            # 学習の最大反復回数 1000
)

model.fit( data, label )
mlxtend.plotting.plot_decision_regions( data, label, model )
plt.show()
