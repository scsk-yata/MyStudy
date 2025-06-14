# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

# tanh関数の定義
def Tanh( x ):
   x = x * 10.0
   return ( np.exp( -x ) - np.exp( +x ) ) / ( np.exp( -x ) + np.exp( +x ) )

# 学習用入力データ X および 教師信号
X = np.array([[1.0, -1.0, -1.0], [1.0, -1.0, 1.0], [1.0, 1.0, -1.0], [1.0, 1.0, 1.0]]).T
t = np.array([-1.0, 1.0, 1.0, -1.0])

# 結合荷重初期値
W = np.array([[1.0, 0.0, 0.0], [1.0, -0.7, -0.3], [1.0, 0.4, 0.6]])
V = np.array([[1.0, 0.8, 0.4]])

# 学習係数
eta = 0.1
for loop in range( 1000 ): # 学習回数1000
  # MLP 順伝搬
  Y = Tanh( np.dot( W, X ) )
  Y[0] = [1,1,1,1] #bias
  Z = Tanh( np.dot( V, Y ) )

  # MLP逆伝搬  勾配計算および結合荷重の更新
  dV = (Z - t*0.99)*(1+Z)*(1-Z)*Y
  dW = np.dot( (Z - t*0.99)*Z*V.T*(1+Y)*(1-Y), X.T )
  V = V - eta * dV.sum( axis=1 ) 
  W = W - eta * dW

print('Z=', Z )
print('W=\n', W )
print('V=\n', V )
