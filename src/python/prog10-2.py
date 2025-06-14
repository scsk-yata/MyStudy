# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt
import sklearn.neural_network # # scikit-learn NN ツールの利用
import mlxtend.plotting # mlxtend 描画ツールの利用

X = np.array([[-1.0, -1.0], [-1.0, 1.0], [1.0, -1.0], [1.0, 1.0]])
t = np.array([-1, 1, 1, -1])

model = sklearn.neural_network.MLPClassifier(
	activation='tanh',       # tanh 関数
	solver='lbfgs',          # Limited memory BFGS 法 で重み更新
	hidden_layer_sizes=(3,), # 隠れ層 ニューロン数 3
	max_iter = 100,          # 学習の最大反復回数 100
)
model.fit( X, t )
mlxtend.plotting.plot_decision_regions( X, t, model )
plt.show()
