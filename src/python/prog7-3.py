# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt

data_num = 400
np.random.seed(1)
class0_data = [9,2] + [3.1, 2.3] * np.random.randn(data_num//2,2)
class1_data = [-10,-4] + [2.7, 3.3] * np.random.randn(data_num//2,2)
label = np.array([ k//200 for k in range(data_num) ] )
data = np.vstack( ( class0_data, class1_data ) )

plt.scatter( class0_data[:,0], class0_data[:,1], marker=',' )
plt.scatter( class1_data[:,0], class1_data[:,1], marker='^' )
plt.show()
