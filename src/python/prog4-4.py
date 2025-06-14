# coding: utf-8  
import numpy as np
import matplotlib.pyplot as plt

def func( x ):
  return ( np.sin(-3.14*x) + np.cos(5.76*x+0.43) + np.sin(0.12*x-0.11) )/3

sample_number = 100
np.random.seed(1)
data_x = 4.0 * np.random.rand(sample_number)-2.0
data_y = func( data_x ) + 0.1 * np.random.randn(sample_number)

train_x = data_x[:80] # 先頭から80個は学習用データ
train_y = data_y[:80]
eval_x = data_x[80:] # 残り20個は検証用データ
eval_y = data_y[80:]

min_train_mse = 100
min_train_n = 1
min_train_a = -1
min_eval_mse  = 100
min_eval_n = 1
min_eval_a = -1
for n in range( 1, 21 ):
   Phi = np.array( [train_x**k for k in range( n+1 )] )
   eval_Phi = np.array( [eval_x**k for k in range( n+1 )] )
   IE = np.identity( n+1 )
   IE[0,0] = 0 
   for a in range( -1, -10, -1 ):
      theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) + (10**a) * IE ), Phi ), train_y )
      train_mse = (( train_y - np.dot( Phi.T, theta ) )**2 ).mean() # 訓練時の誤差
      eval_mse  = (( eval_y  - np.dot( eval_Phi.T, theta ) )**2 ).mean() # 評価時の誤差
      print('n= {0:2d} log10(alpha)={1:2d} : Train error={2:7.5f} Eval error={3:7.5f}'.format( n, a, train_mse, eval_mse ) )
      if train_mse < min_train_mse:
         min_train_mse, min_train_n, min_train_a = train_mse, n, a
      if eval_mse < min_eval_mse:
         min_eval_mse, min_eval_n, min_eval_a = eval_mse, n, a

# 学習時平均二乗誤差最小パラメータでの結果
Phi = np.array( [train_x**k for k in range( min_train_n+1 )] )
IE = np.identity( min_train_n+1 )
IE[0,0] = 0 
theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) + (10**min_train_a) * IE ), Phi ), train_y )
plt.scatter( train_x, train_y, color='black' ) # 訓練データの描画
plt.scatter( eval_x,  eval_y,  color='black' ) # 評価データの描画
xx = np.linspace( -1.99, +1.99, 399 )  #  -1.99から+1.99まで399点分割（グラフ描画用）
P = np.array( [xx**k for k in range( min_train_n+1 )] )  # グラフ描画用データの生成
plt.plot( xx, np.dot( P.T, theta), color='black', linewidth='1.0' )
plt.plot( xx, func(xx), color='black', linewidth='1.0', linestyle='dashed' )
plt.xlabel('data_x')
plt.ylabel('data_y')
plt.show()

# 検証時平均二乗誤差最小パラメータでの結果
Phi = np.array( [train_x**k for k in range( min_eval_n+1 )] )
IE = np.identity( min_eval_n+1 )
IE[0,0] = 0 
theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) + (10**min_eval_a) * IE ), Phi ), train_y )
plt.scatter( train_x, train_y, color='black' ) # 訓練データの描画
plt.scatter( eval_x,  eval_y,  color='black' ) # 評価データの描画
xx = np.linspace( -1.99, +1.99, 399 )  #  -1.99から+1.99まで399点分割（グラフ描画用）
P = np.array( [xx**k for k in range( min_eval_n+1 )] )  # グラフ描画用データの生成
plt.plot( xx, np.dot( P.T, theta), color='black', linewidth='1.0' )
plt.plot( xx, func(xx), color='black', linewidth='1.0', linestyle='dashed' )
plt.xlabel('data_x')
plt.ylabel('data_y')
plt.show()
