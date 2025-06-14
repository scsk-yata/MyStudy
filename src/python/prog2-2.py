#coding:utf-8
import numpy as np
import matplotlib.pyplot as plt
import sklearn.decomposition

np.random.seed( 1 )
data = np.random.randn( 200, 2 )
A = np.array([[1,2.5],[-15,-2.5]])
data = np.dot( data, A ) + [ -10.2, 18.7 ]

# 元のデータの散布図の描画
plt.scatter( data[:,0], data[:,1] )
plt.show()

# 標準化したデータの散布図の描画
std_data = ( data - data.mean(axis=0) ) / data.std(axis=0)
plt.scatter( std_data[:,0], std_data[:,1] )
plt.show()

# 主成分分析
model = sklearn.decomposition.PCA( n_components=2 )
pca_data = model.fit_transform( std_data )
# 主成分および因子寄与率の表示
print('Eigenvectors: \n', model.components_ )
print('Variance ratio: \n', model.explained_variance_ratio_ )

# 主成分分析したデータの散布図の描画
plt.scatter( pca_data[:,0], pca_data[:,1] )
plt.show()