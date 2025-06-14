#coding:utf-8
import numpy as np
import matplotlib.pyplot as plt
import sklearn.decomposition

np.random.seed( seed=1 )
latent1 = np.array([ np.random.randn() for k in range(100)])
latent2 = np.array([ np.random.randn() for k in range(100)])
x = 2.1 * latent1 + 0.2 * latent2
y = 0.3 * latent1 + 3.4 * latent2
z = latent1 - latent2

# データを標準化
x = ( x - x.mean() ) / x.std()
y = ( y - y.mean() ) / y.std()
z = ( z - z.mean() ) / z.std()

# scikit-learn で主成分分析
data = np.array([x,y,z]).T
model = sklearn.decomposition.PCA( n_components=3 )
pca_data = model.fit_transform( data )

print( '標準化したデータの共分散行列:\n', np.cov( data.T ) )
print( '主成分分析したデータの共分散行列:\n', np.cov( pca_data.T ) )

print( '第1主成分から第3主成分:\n', model.components_ )
print( '各主成分の寄与率:\n', model.explained_variance_ratio_ )
