# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt

def func( x ):
  return ( np.sin(-3.14*x) + np.cos(5.76*x+0.43) + np.sin(0.12*x-0.11) )/3

sample_number = 100
s = 0.1
n = 12
np.random.seed(1)
data_x = 4.0 * np.random.rand(sample_number)-2.0
data_y = func( data_x ) + s * np.random.randn(sample_number)

train_x = data_x[:80] # 先頭から80個はトレーニング用データ
train_y = data_y[:80]
eval_x = data_x[80:] # 残り20個はテスト用データ
eval_y = data_y[80:]

Phi = np.array([ train_x**i for i in range( n+1 ) ])
eval_Phi = np.array([ eval_x**i for i in range( n+1 ) ])
theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) ), Phi ), train_y )
train_mse = (( np.dot( Phi.T, theta ) - train_y )**2 ).mean()
eval_mse  = (( np.dot( eval_Phi.T, theta ) - eval_y )**2 ).mean()
train_sigma = np.sqrt( train_mse )
eval_sigma  = np.sqrt( eval_mse )
print('Train: MSE=', train_mse, '  Sigma=', train_sigma )
print('Eval : MSE=', eval_mse,  '  Sigma=', eval_sigma )
x_pred = np.linspace( -2.0, 2.0, 2001 ) # 予測曲線描画用に入力データ(-1から１まで0,001刻み）を用意
pred_Phi = np.array([ x_pred**i for i in range( n+1 ) ])
y_pred = np.dot( pred_Phi.T, theta ) # 予測
plt.plot( x_pred, y_pred, color='red' ) # 予測曲線の描画
plt.scatter( train_x, train_y )
plt.scatter( eval_x,  eval_y )
plt.fill_between( x_pred, y_pred+train_sigma*3, y_pred-train_sigma*3, alpha=0.1, label='sigma')
plt.fill_between( x_pred, y_pred+train_sigma, y_pred-train_sigma, alpha=0.1, label='sigma')
plt.xlabel('data_x')
plt.ylabel('data_y')
plt.show()
