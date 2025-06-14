# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
import sklearn.svm
import sklearn.datasets
import sklearn.decomposition
import mlxtend.plotting

np.random.seed( 1 )
data, label=sklearn.datasets.make_moons(n_samples=200, shuffle=True, noise=0.15, random_state=1 )
A = np.array([[10.0*np.cos(np.pi/4), np.sin(np.pi/4)],[-10.0*np.sin(np.pi/4), np.cos(np.pi/4)]])
data = np.dot( data, A ) + [100.0, -10.0]
label = np.array([ -1 if k==0 else 1 for k in label])

model = sklearn.svm.SVC( kernel='rbf' )
# 元データを rbfカーネルで分類
model.fit( data, label )
mlxtend.plotting.plot_decision_regions( data, label, model )
plt.show()

# 元データの標準化し、標準化データを rbfカーネルで分類
std_data = ( data - data.mean(axis=0) ) / data.std(axis=0)
model.fit( std_data, label )
mlxtend.plotting.plot_decision_regions( std_data, label, model )
plt.show()
