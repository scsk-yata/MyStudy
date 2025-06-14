#coding: utf-8
import numpy as np
import matplotlib.pyplot as plt

x = np.arange( -1, +1.1, 0.2 )
ya = np.array([-0.26114704, 0.04081065, 0.40065032, 0.65437830, 0.66576410, 0.36474044, -0.21419675, -0.89358835, -1.31461206, -0.89868233, 1.19094953])
yb = np.array([ 0.06372203, -0.08154063, 0.29501597, 0.43978457, 0.83884562, -0.09556730, 0.13476560, -1.04582973, -1.25080424, -0.94855641, 1.48337112])

for n in range( 1, 11 ):
   print('n=', n )
   Phi = np.array([ x**k for k in range( n+1 ) ])
   theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) ), Phi ), ya )
   print('theta =', theta )
   pred_y = np.dot( Phi.T, theta )
   mse = ((ya-pred_y)**2).mean()
   print('MSE=', mse )

   xx = np.linspace( -1.0, +1.0, 201 )
   P = np.array( [ xx**k for k in range( n+1 ) ])
   y_pred = np.dot( P.T, theta )
   plt.scatter( x, ya, color='blue' )
   plt.plot( xx, y_pred, color='red' )
   plt.show()
