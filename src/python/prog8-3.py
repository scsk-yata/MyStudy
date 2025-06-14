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

plt.scatter( data[label==0,0], data[label==0,1], marker='s' )
plt.scatter( data[label==1,0], data[label==1,1], marker='^' )
plt.show()
