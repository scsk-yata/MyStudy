# coding:utf-8
import numpy as np
import matplotlib.pyplot as plt

def k( x, mu, sigma ):
   return np.array([ np.exp( -(( x - m )**2 ) / ( 2 * sigma**2 )) for m in mu ])

x = np.array( [-0.4, -0.5667, 0.2333, 0., 0.0667, -0.3333, 0.3333, 0.5, -0.6, -0.2333] )
y = np.array( [-0.3333, -0.2333, 0.2667, 0.2333, 0.3, -0.0667, 0.4667, 0.4333, -0.3, 0.0667] )
sigma = (x.max()-x.min())/(len(x)-1) # データが等間隔に存在するときのデータ間の距離
K = k( x, x, sigma )
l = 0.5  # python では lambda が予約語であるため、l を使用
theta = np.dot( np.linalg.inv( K + l * np.identity( len( K ) ) ), y.T )
plt.scatter( x, y, color='blue' ) # 学習データの描画
xx = np.linspace( -0.6, +0.6, 1201 )
P = k( xx, x, sigma )
plt.ylim([-0.6,+0.6])
plt.xlim([-0.6,+0.6])
plt.plot( xx, np.dot( P.T, theta ), color='red', linewidth='1.0' )
plt.show() # グラフの表示
