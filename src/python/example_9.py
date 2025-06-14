# オブジェクト指向インターフェースを用いたグラフの描画 
# example_9.py
import numpy as np
import matplotlib.pyplot as plt 

t = np.arange(0, 2*np.pi, 0.1)
y = np.sin(t)
fig = plt.figure()  # fig.で設定するため
ax = fig.add_subplot(1, 1, 1)#オブジェクト指向インターフェースの特徴
ax.plot(t, y)
ax.set_xlim(0, 2*np.pi); ax.set_ylim(-2, 2) 
ax.grid(False)
ax.set_xlabel('Time $t$') 
ax.set_ylabel('Output $y(t)$')
plt.show()