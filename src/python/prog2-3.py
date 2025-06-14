#coding:utf-8
import numpy as np
import matplotlib.pyplot as plt
import sklearn.decomposition

np.random.seed( seed=1 )
latent1 = np.array([ np.random.randn() for k in range(100)])
latent2 = np.array([ np.random.randn() for k in range(100)])
x = 2.1 * latent1 + 0.2 * latent2
y = 0.3 * latent1 + 3.4 * latent2
z = latent1 - latent2
