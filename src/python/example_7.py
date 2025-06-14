# プログラム例 # example_7.py
import numpy as np
a, b = 2, 3 # 方程式 a*x* + b = 0 の係数
if (a == 0) and (b == 0):
    print('a == 0, b == 0, Indeterminate equation') # 不確定な式
elif (a == 0) and (b != 0): #elif
    print('a == 0, b != 0, Impossible equation.')    
else:
    print('a != 0')
    x = -b / a
    print('x = ', x)
