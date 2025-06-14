# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

data = np.array([ [-7.6366, 4.4345] ,  [-0.8298,  5.893 ] , [-5.2367,  9.7781] , [-8.0176,  4.9071] , [-3.5089,  3.2886] , [-7.1236,  9.0147] , [-1.4804,  3.7145] , [-6.0853,  5.9782] , [-1.9547,  5.2760] , [-2.6335,  0.6570] , [ 5.9805, -6.1199] , [-0.3511, -4.0890] , [-0.3488, -0.3379] , [ 2.8886,  0.4592] , [ 3.3471, -4.1771] , [ 4.6872, -1.2454] , [ 4.6730,  0.1728] , [ 4.6227, -2.4600] , [ 6.0332, -3.2413] , [-2.7488 ,-4.8465] ] ).T
t = np.array([[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]]).T
Phi = np.vstack((  np.ones( data.shape[1] ), data ))

# theta の初期値
theta = np.array([[ 1.0, 1.0, 1.0]]).T

for k, d in enumerate( data.T ):
   if t[k]==1:
      # t= +1 の点の描画
      plt.scatter( d[0], d[1], marker='x', color='red'  )  
   else:
      # t= ー1 の点の描画
      plt.scatter( d[0], d[1], marker='^', color='blue' )  

# 識別関数の描画
xx = np.linspace( -10.0, 10.0, 201 )
yy = -( theta[0] + xx * theta[1] ) / theta[2]

plt.plot( xx, yy, color='purple' )

eta = 0.2 # 学習率パラメータ
# 識別失敗している点が存在している間、繰り返す
while np.count_nonzero( np.dot( Phi.T, theta ) * t < 0 ) > 0:
   for k in range( data.shape[1] ):
      # 識別失敗している場合
      if np.dot( Phi[:,k] ,theta ) * t[k] < 0.0 : 
         # theta の値を更新
         theta = theta +  eta * Phi[:,k:k+1] * t[k] 
         # 識別関数の描画
         yy = -( theta[0] + xx * theta[1] ) / theta[2]   
         plt.plot( xx, yy, color='purple' ) 
plt.plot( xx, yy, color='green' ) 
plt.xlim( -10.0, +10.0 )
plt.ylim( -10.0, +10.0 )
plt.show()
