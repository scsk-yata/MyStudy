# coding: utf-8
import numpy as np
import matplotlib.pyplot as plt
import sklearn.svm
import mlxtend.plotting

data = np.array([ [ 1.1, 1.1], [ -0.9, 0.9], [ -1.0, -1.0],  [ 1.0, -1.0] ])
label = np.array([ +1, -1, +1, -1 ])

model = sklearn.svm.SVC( kernel='linear', C=100 )
model.fit( data, label )
print( model.support_vectors_ )
print( model.dual_coef_ )
print( model.intercept_ )
mlxtend.plotting.plot_decision_regions( data, label, model )
plt.show()
