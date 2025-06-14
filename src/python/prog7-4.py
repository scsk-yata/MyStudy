# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

data_num = 400
np.random.seed(1)
class0_data = [9,2] + [3.1, 2.3] * np.random.randn(data_num//2,2)
class1_data = [-10,-4] + [2.7, 3.3] * np.random.randn(data_num//2,2)
label = np.array([ k//200 for k in range(data_num) ] )
data = np.vstack( ( class0_data, class1_data ) )

mu0=np.array([np.mean( class0_data, axis=0 )]).T  # cls1 の平均を取り 2次元テンソルに変換
mu1=np.array([np.mean( class1_data, axis=0 )]).T
sw = np.zeros((class0_data.shape[1], class1_data.shape[1]))
for k in range( class0_data.shape[0] ):
   sw += np.dot( (class0_data[k:k+1,:].T-mu0), (class0_data[k:k+1,:].T-mu0).T )
for k in range( class1_data.shape[0] ):
   sw += np.dot( (class1_data[k:k+1,:].T-mu1), (class1_data[k:k+1,:].T-mu1).T )
theta = np.dot( np.linalg.inv( sw ), ( mu0 - mu1 ) )
s0 = np.std( np.dot( class0_data, theta ) )   # クラス1データを w 上に写像した際の標準偏差
s1 = np.std( np.dot( class1_data, theta ) )   # クラス2データを w 上に写像した際の標準偏差
c = ( s0 * mu1 + s1 * mu0 ) / ( s0 + s1 ) #各クラスの標準偏差からバイアスを与えるベクトルを計算
theta = np.vstack(( -np.dot( c.T, theta ), theta )) # theta[0](バイアス値)を計算し付加
print( 'theta=\n', theta )


xx = np.linspace( -10, 10, 31 )
yy = -( theta[0] + xx * theta[1] ) / theta[2] # 識別関数の描画

plt.plot( xx, yy, color='green' )

plt.scatter( class0_data[:,0], class0_data[:,1], marker=',' )
plt.scatter( class1_data[:,0], class1_data[:,1], marker='^' )
plt.xlabel( r'$x_i$', fontsize=20 )
plt.ylabel( r'$y_i$', fontsize=20 )
plt.xlim( -10.0, +10.0 )
plt.ylim( -10.0, +10.0 )

plt.show()
