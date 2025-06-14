# coding:utf-8
import numpy as np
import matplotlib.pyplot as plt

def k( x, mu, sigma ):
   tmp = np.array([ np.exp( -(( x - m )**2 ) / ( 2 * sigma**2 )) for m in mu ])
   return np.vstack( [tmp, np.ones( len( x ))] )

x = np.array( [-0.4, -0.5667, 0.2333, 0., 0.0667, -0.3333, 0.3333, 0.5, -0.6, -0.2333] )
y = np.array( [-0.3333, -0.2333, 0.2667, 0.2333, 0.3, -0.0667, 0.4667, 0.4333, -0.3, 0.0667] )
mu = np.linspace(-0.6, 0.6, 7) # 等間隔で7点

sigma = np.sqrt( 1/200 )
Phi = k( x, mu, sigma )
theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) ), Phi ), y.T )
plt.scatter( x, y, color='blue' ) # データの描画
xx = np.linspace( -0.6, +0.6, 1201 )
P = k( xx, mu, sigma )
plt.ylim([-0.6,+0.6])
plt.xlim([-0.6,+0.6])
plt.plot( xx, np.dot( P.T, theta ), color='red', linewidth='1.0' )
plt.show() # グラフの表示
