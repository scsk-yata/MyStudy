# -*- coding: utf-8 -*- 
import numpy as np
import matplotlib.pyplot as plt

def func( x ):
  return ( np.sin(-3.14*x)+np.cos(5.76*x+0.43)+np.sin(0.12*x-0.11) )/3

sample_number = 100
s = 0.1
np.random.seed(1)
data_x = 4.0 * np.random.rand(sample_number)-2.0
data_y = func( data_x ) + s * np.random.randn(sample_number)

plt.scatter( data_x, data_y, color='blue' )
plt.xlabel('data_x')
plt.ylabel('data_y')
plt.show()
