import numpy as np
from scipy import signal
from mycircconv import mycircconv

h = np.array([8, 4, 2, 1])  # 信号h
x = np.array([1, 2, 3, 4])  # 信号x
y = signal.convolve(h, x)   # 線形たたみこみ　すれ違いだから出力は長さ+3
print('y = \n', y)
yc = mycircconv(h, x)       # 循環たたみこみ
print('yc = \n', yc)
