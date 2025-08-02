# プログラム例　example_6.py
import numpy as np
x = -22 
print('x =', x)
if  x >= 0:
    root_x = np.sqrt(x)
else:
    root_x = np.sqrt(-x) * 1j #複素数は1j
print('root of x =', root_x)