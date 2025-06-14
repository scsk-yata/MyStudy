import numpy as np
import matplotlib.pyplot as plt
import math

sample_rate = 1.0e5
carrier_freq = 100.0e2
duration = 10.0e-3

xs = np.arange(0, duration, 1/sample_rate)
ys = np.sin(2.0*np.pi*carrier_freq*xs)              # 搬送波
bs = np.array([1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1,  # ディジタルビット列
     1, 1, 1, 0, 0, 1, 1, 1], dtype=float)
bs_resampled = np.array([bs[i//(len(xs)//len(bs))] 
     for i in range(len(xs))])     # アップサンプリング
ms = [np.sin(2.0*np.pi*carrier_freq*xs[i] + np.pi*bs_resampled[i])
     for i in range(len(xs))]      # FSK変調

fig = plt.figure()
ax1 = fig.add_subplot(2, 1, 1)
ax1.plot(xs, bs_resampled, 'b')
ax1.set_title('Bit Stream(upper) and PSK modulated signal')
ax2 = fig.add_subplot(2, 1, 2)
ax2.set_xlabel('Time(sec)')
ax2.plot(xs, ms, 'b')

plt.show()