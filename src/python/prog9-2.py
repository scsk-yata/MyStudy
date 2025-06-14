# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

data = np.array([ [-7.6366, 4.4345] ,  [-0.8298,  5.893 ] , [-5.2367,  9.7781] , [-8.0176,  4.9071] , [-3.5089,  3.2886] , [-7.1236,  9.0147] , [-1.4804,  3.7145] , [-6.0853,  5.9782] , [-1.9547,  5.2760] , [-2.6335,  0.6570] , [ 5.9805, -6.1199] , [-0.3511, -4.0890] , [-0.3488, -0.3379] , [ 2.8886,  0.4592] , [ 3.3471, -4.1771] , [ 4.6872, -1.2454] , [ 4.6730,  0.1728] , [ 4.6227, -2.4600] , [ 6.0332, -3.2413] , [-2.7488 ,-4.8465] ] ).T
t = np.array([[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]]).T
Phi = np.vstack((  np.ones( data.shape[1] ), data ))

# シグモイド関数の定義
def sigmoid( x ):
  return 1.0 / ( 1.0 + np.exp( -x ) )

# theta の初期値
theta = np.array([[ 1.0, 1.0, 1.0]]).T 

for k, d in enumerate( data.T ):
   if t[k]==1:
      # t=+1 を点を描画
      plt.scatter( d[0], d[1], marker='x', color='red'  )  
   else:
      # t=-1 を点を描画
      plt.scatter( d[0], d[1], marker='^', color='blue' )  

eta = 0.2 # 学習率パラメータ
xx = np.linspace( -10.0, 10.0, 201 )
while True: # 無限ループ
   # 識別関数の描画
   yy = -( theta[0] + xx * theta[1] ) / theta[2]
   plt.plot( xx, yy, color='purple' )
   diff = theta.copy()
   # theta のバッチ学習
   theta = theta +  eta * np.dot( Phi, t - sigmoid( np.dot( Phi.T,  theta ) ) )
   # theta を2 次ノルムで正規化
   theta = theta / np.linalg.norm( theta, ord=2 )  
   if (diff-theta).all() < 10**(-4): 
      break # 条件を満足したらループから抜け出す
plt.plot( xx, yy, color='green' ) 
plt.xlim( -10.0, +10.0 )
plt.ylim( -10.0, +10.0 )
plt.show()
