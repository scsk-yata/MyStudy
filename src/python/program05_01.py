import numpy as np
from myconvolve import myconvolve

h = np.array([1, 3, -1])    # 単位インパルス応答
x = np.array([2, 1, 5, 3])  # 入力
y = myconvolve(h, x)        # hとxのたたみこみ　関数の中で引数の長さを零詰めで揃えてくれる
print('y = \n', y)