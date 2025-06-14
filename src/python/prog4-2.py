# coding:utf-8
import numpy as np
import matplotlib.pyplot as plt

data = np.array([ [-0.0017, -0.1851], [ 0.0418, -0.1354], [ 0.0411, -0.0908], [ 0.0335, -0.0791], [ 0.1949, -0.0785], [-0.2201,  0.0433], [ 0.2622,  0.0862], [ 0.1161,  0.0363], [-0.0513, -0.1870], [-0.0570, -0.2675], [-0.2671, -0.3310], [-0.2283, -0.0819], [ 0.2265, -0.0464], [ 0.0357, -0.0772], [ 0.2866,  0.1624], [-0.0313, -0.2382], [-0.2184, -0.0450], [-0.0439, -0.2709], [-0.1028, -0.2313], [-0.1977, -0.0018], [ 0.1983, -0.0819], [ 0.0666, -0.0333], [-0.2654, -0.2203], [-0.0733, -0.1929], [ 0.1139,  0.0005], [-0.0456, -0.2739], [-0.1715, -0.0781], [-0.2114,  0.0827], [ 0.0584, -0.0569], [ 0.2585, -0.0054] ])

train = data[:20]  # 最初の20組を訓練データ
eval  = data[20:]  # 残りは評価データ
n = 19   # 次数の設定
alpha = 10**(-30) # 正則化パラメータ
# 訓練用データの生成
Phi = np.array( [train[:,0]**k for k in range( n+1 )] )
# 評価用データの生成
eval_Phi = np.array( [eval[:,0]**k for k in range( n+1 )] ) 
IE = np.identity( n+1 )  # 単位行列
IE[0,0] = 0   # バイアス項は正則化から除外
theta = np.dot( np.dot( np.linalg.inv( np.dot( Phi, Phi.T ) + alpha * IE ), Phi ), train[:,1] )
# 誤差の導出
train_mse = (( train[:,1] - np.dot( Phi.T, theta ) )**2 ).mean()
eval_mse  = (( eval[:,1]  - np.dot( eval_Phi.T, theta ) )**2 ).mean()
print('n= {0:2d} : Train MSE={1:7.5f} Eval MSE={2:7.5f}'.format( n, train_mse, eval_mse ) )

# 訓練データの描画
plt.scatter( train[:,0], train[:,1], color='black' ) 
# 評価データの描画
plt.scatter( eval[:,0],  eval[:,1],  color='black', marker='*'  ) 
xx = np.linspace( -0.3, +0.3, 61 )  
# グラフ描画用データの生成
P = np.array( [xx**k for k in range( n+1 )] )  
plt.ylim([-0.4,+0.4])
plt.xlim([-0.3,+0.3])
plt.plot( xx, np.dot( P.T, theta ), color='red', linewidth='1.0' )
plt.show() # グラフの表示
