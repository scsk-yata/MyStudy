# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

data_num = 400
np.random.seed(1)
class0_data = [9,2] + [3.1, 2.3] * np.random.randn(data_num//2,2)
class1_data = [-10,-4] + [2.7, 3.3] * np.random.randn(data_num//2,2)
label = np.array([[ k//200 for k in range(data_num) ]] ).T
data = np.vstack( ( class0_data, class1_data ) ).T

def sigmoid( x ):      # シグモイド関数の定義
  return 1.0 / ( 1.0 + np.exp( -x ) )

Phi = np.vstack((  np.ones( data.shape[1] ), data ))
theta = np.array([[ 0.0, 1.0, -1.0]]).T      # theta の初期値

eta = 0.1 # 学習率パラメータ
while True:
   diff = theta.copy()
   theta = theta +  eta * np.dot( Phi, label - sigmoid( np.dot( Phi.T,  theta ) ) )
   theta = theta / np.linalg.norm( theta, ord=2 )
   if (diff-theta).all() < 10**(-4): # 条件を満足したらループから抜け出す
      break

xx = np.linspace( -10, 10, 21 )
yy = -( theta[0] + xx * theta[1] ) / theta[2]
plt.plot( xx, yy, color='green' )

plt.scatter( class0_data[:,0], class0_data[:,1], marker='x' )
plt.scatter( class1_data[:,0], class1_data[:,1], marker='^' )
plt.show()
