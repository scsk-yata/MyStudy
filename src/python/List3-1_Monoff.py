# Plot sin function

import numpy as np
import matplotlib.pyplot as plt
import math
# モールスon-off
sample_rate = 1.0e5
carrier_freq = 1.0e2
duration = 1.0e0
#xs, step = np.linspace(0, duration, num=duration*sample_rate) スタート，ストップ，分割数を入力
xs = np.arange(0, duration, 1/sample_rate)
ys1 = np.sin(2.0*np.pi*carrier_freq*xs)
ys2 = [1.0]*10000 + [0.0]*10000 + [1.0]*10000 + [0.0]*10000 + [1.0]*10000 + [0.0]*10000 + [1.0]*30000 + [0.0]*10000
ys3 = ys1 * ys2
# Numpyでは[値]*幅(整数)で配列が作れる
plt.plot(xs, ys3, 'r')
plt.xlabel('Time(sec)')
plt.ylabel('sin(2*pi*f*t)')

plt.show()