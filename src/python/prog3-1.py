#coding:utf-8
import numpy as np
import matplotlib.pyplot as plt

n = 1 # 推定次数
x = np.array( [ -0.1660,  0.4406, -0.9998, -0.3953, -0.7065, -0.8153, -0.6275, -0.3089, -0.2065,  0.0776 ])
y = np.array( [  0.1834,  0.4484, -0.6679, -0.2110, -0.3043, -0.7490, -0.4156, -0.1510,  0.0879,  0.1060 ])
Phi = np.array( [ x**k for k in range( n+1 ) ] )
theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) ), Phi ), y )
print('theta =', theta )
pred_y = np.dot( Phi.T, theta )
mse = ((y-pred_y)**2).mean()
print('MSE=', mse )

xx = np.linspace( -1.1, +1.1, 221 )
P = np.array( [ xx**k for k in range( n+1 ) ])
plt.xlim([-1.1,+1.1])
plt.ylim([-0.8,+1.1])
plt.xlabel('X', fontsize=18)
plt.ylabel('Y', fontsize=18)
plt.plot( xx, np.dot(P.T, theta), color='red' )
plt.scatter( x, y, color='blue', marker='*' )
plt.show()
