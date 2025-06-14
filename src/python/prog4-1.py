#coding:utf-8
import numpy as np
import matplotlib.pyplot as plt

x = np.array( [ -0.1660,  0.4406, -0.9998, -0.3953, -0.7065, -0.8153, -0.6275, -0.3089, -0.2065,  0.0776 ])
y = np.array( [  0.1834,  0.4484, -0.6679, -0.2110, -0.3043, -0.7490, -0.4156, -0.1510,  0.0879,  0.1060 ])
xx = np.linspace( -0.7, +0.71, 141 )
for n in range( 1, 11 ):  # 次数nを1から11まで変化させる
   Phi = np.array( [ x**k for k in range( n+1 ) ] )
   theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) ), Phi ), y )
   mse = (( y - np.dot( Phi.T, theta ) )**2 ).mean()
   print('n= {0:2d} : {1:7.5f}'.format( n, mse ) )
   plt.scatter( x, y, color='blue' ) # 散布図の描画
   P = np.array( [xx**k for k in range( n+1 )] )
   plt.ylim([-0.5,+0.5])
   plt.xlim([-0.7,+0.7])
   plt.plot( xx, np.dot( P.T, theta ), color='red', linewidth='1.0' )
   plt.show()
