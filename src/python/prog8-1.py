# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
import sklearn.svm
import mlxtend.plotting

data = np.array(
[[-1.0, 6.3], [-1.0, 4.0], [-2.3, 7.6], [-1.9, 4.3], [-3.3, 5.0], [-4.1, 2.9], [-4.2, 0.8], [-5.3, 6.2], [-4.7, 5.2], [-5.9, 1.7], [-1.0, 2.0], [ 1.0, 0.0],  [ 1.0,-5.9], [ 2.0,-1.0], [ 1.8,-2.4], [ 2.9, 1.1],  [ 4.3, 2.4], [ 3.7,-4.1], [ 5.6, 3.4], [ 5.3,-2.8],  [ 5.7, 4.7], [ 1.0, 2.0] ])

label = np.array(  [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, +1, +1, +1, +1, +1, +1, +1, +1, +1, +1, +1 ])

model = sklearn.svm.SVC( kernel='linear', C=100 )
model.fit( data, label )
print( 'support_vectors_ \n', model.support_vectors_ )
print( 'dual_coef_ \n', model.dual_coef_ )
print( 'coef_ \n', model.coef_ )
print( 'intercept_ \n', model.intercept_ )

plt.rc('text', usetex=True)
plt.rc('font', family='serif')
mlxtend.plotting.plot_decision_regions( data, label, model )
plt.xlabel( r'$x_i$', fontsize=20 )
plt.ylabel( r'$y_i$', fontsize=20 )
plt.show()
