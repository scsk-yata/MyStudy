# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt

data = np.array([[-7.6366, 4.4345],  [-0.8298,  5.893 ], [-5.2367,  9.7781], [-8.0176,  4.9071], [-3.5089,  3.2886], [-7.1236,  9.0147], [-1.4804,  3.7145], [-6.0853,  5.9782], [-1.9547,  5.2760], [-2.6335,  0.6570], [ 5.9805, -6.1199], [-0.3511, -4.0890], [-0.3488, -0.3379], [ 2.8886,  0.4592], [ 3.3471, -4.1771], [ 4.6872, -1.2454], [ 4.6730,  0.1728], [ 4.6227, -2.4600], [ 6.0332, -3.2413], [-2.7488 ,-4.8465]])
Phi = np.vstack((np.array([np.ones(data.shape[0])]), data.T))
t = np.array([ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]) 

cls1=data.copy()   # data を cls1 に深いコピー
cls2=data.copy()   # data を cls2 に深いコピー
for k in reversed(range( len(t) )): 
  if t[k] == t[0]:
    # t[k] と t[0] が一致した行を削除 (axis=0 で行)
    cls1 = np.delete( cls1, k, axis=0 )  
  else:
    # t[k] と t[0] が一致しなかった行を削除 (axis=0 で行)
    cls2 = np.delete( cls2, k, axis=0 )  

# cls1 の平均を取り 2次元テンソルに変換
mu1=np.array([np.mean( cls1, axis=0 )]).T
# cls2 の平均を取り 2次元テンソルに変換
mu2=np.array([np.mean( cls2, axis=0 )]).T
sw = np.zeros((cls1.shape[1], cls1.shape[1]))

for k in range( cls1.shape[0] ):
  sw += np.dot((cls1[k:k+1,:].T-mu1), (cls1[k:k+1,:].T-mu1).T)
for k in range( cls2.shape[0] ):
  sw += np.dot((cls2[k:k+1,:].T-mu2), (cls2[k:k+1,:].T-mu2).T)
theta = np.dot( np.linalg.inv( sw ), ( mu1 - mu2 ) )
theta = theta /  np.linalg.norm( theta, ord=2 )
# クラス1データを w 上に写像した際の標準偏差
s1 = np.std( np.dot( cls1,  theta ) )  
# クラス2データを w 上に写像した際の標準偏差
s2 = np.std( np.dot( cls2,  theta ) )  
# 各クラスの標準偏差からバイアスを与えるベクトルを計算
c = ( s1 * mu2 + s2 * mu1 ) / ( s1 + s2 ) 
# theta[0](バイアス値)を計算し付加
theta = np.vstack(( -np.dot( c.T, theta ), theta )) 
print( 'theta=\n', theta )

xx = np.linspace( -10, 10, 21 )
yy = -( theta[0] + xx * theta[1] ) / theta[2]   # 識別関数の描画
plt.figure( figsize=(8,8) )
plt.scatter( data[:10,0], data[:10,1], color='red' )
plt.scatter( data[10:,0], data[10:,1], color='blue' )
plt.plot( xx, yy, color='green' )
plt.xlim( -10.0, +10.0 )
plt.ylim( -10.0, +10.0 )
plt.show()
