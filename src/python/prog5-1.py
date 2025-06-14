# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt

x = np.array([ -0.0017, 0.0418, 0.0411, 0.0335, 0.1949, -0.2201, 0.2622, 0.1161, -0.0513, -0.0570, -0.2671, -0.2283, 0.2265, 0.0357, 0.2866, -0.0313, -0.2184, -0.0439, -0.1028, -0.1977, 0.1983, 0.0666, -0.2654, -0.0733, 0.1139, -0.0456, -0.1715, -0.2114, 0.0584, 0.2585])
y = np.array([-0.1851, -0.1354, -0.0908, -0.0791, -0.0785, 0.0433, 0.0862, 0.0363, -0.1870, -0.2675, -0.3310, -0.0819, -0.0464, -0.0772, 0.1624, -0.2382, -0.0450, -0.2709, -0.2313, -0.0018, -0.0819, -0.0333, -0.2203, -0.1929, 0.0005, -0.2739, -0.0781, 0.0827, -0.0569, -0.0054])

Phi = np.array([ x**i for i in range( 6 ) ])
theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) ), Phi ), y )

x_pred = np.linspace( x.min(), x.max(), 5000 )
pred_Phi = np.array([ x_pred**i for i in range( 6 ) ])
y_pred = np.dot( pred_Phi.T, theta )

mse = (( np.dot( Phi.T, theta ) - y )**2 ).mean()
sigma = np.sqrt( mse )
print('MSE=', mse, '  Sigma=', sigma )

plt.plot( x_pred, y_pred, color='red' ) # 予測曲線の描画
plt.scatter( x, y ) # トレーニングデータの描画
plt.fill_between( x_pred, y_pred+sigma*3, y_pred-sigma*3, alpha=0.1, label='sigma')
plt.fill_between( x_pred, y_pred+sigma, y_pred-sigma, alpha=0.1, label='sigma')
plt.show()
