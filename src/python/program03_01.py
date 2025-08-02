import math
import numpy as np
from scipy import signal
from mydft import mydft # 開いているフォルダ内の自作関数
import matplotlib.pyplot as plt

# 信号　len(オブジェクト)は組み込み関数
x = np.array([1, 1, 1, 1, 0, 0, 0, 0])                # 8点の信号
n = np.arange(0, len(x))                              # 時間のインデックス
fig1 = plt.figure()
ax1 = fig1.add_subplot(1, 1, 1)
ax1.stem(n, x)                                        # 信号の図示
ax1.set_xlim(0, len(x)); ax1.set_ylim(np.min(x), np.max(x)); ax1.grid()
ax1.set_xlabel('Time $n$')
ax1.set_ylabel('$x[n]$')

# 離散時間フーリエ変換 DTFT πは含まない
w = np.linspace(-np.pi, np.pi, 1024, endpoint=False)  # 周波数の範囲と刻み（の数）
_, Xejw = signal.freqz(x, 1, w)                       # 離散時間フーリエ変換の計算
#Xejw = signal.freqz(x, 1, w) 第一出力はx軸の範囲-π～π
fig2 = plt.figure()
ax2 = fig2.add_subplot(1, 1, 1)
maxX = np.max(np.abs(Xejw))                           # 振幅スペクトルの最大値
ax2.plot(w, np.abs(Xejw))                             # 振幅スペクトルの図示
ax2.set_xlim(-np.pi, np.pi); ax2.set_ylim(0, maxX); ax2.grid()
ax2.set_xlabel('Frequency $\omega$ [rad]')
ax2.set_ylabel('$|X(e^{j\omega})|$')

# 離散フーリエ変換DFT
k = n                                                 # 周波数のインデックス
print('k =', k)
X = mydft(x)                                          # 離散フーリエ変換の計算
print('X =\n', X)
magX = np.abs(X)                                      # 振幅スペクトル
print('magX =\n', magX)
fig3 = plt.figure()
ax3 = fig3.add_subplot(1, 1, 1)
ax3.stem(k, magX)                                     # 振幅スペクトルの図示
ax3.set_xlim(0, len(k)); ax3.set_ylim(0, maxX); ax3.grid()
ax3.set_xlabel('Frequency $k$')
ax3.set_ylabel('$|X[k]|$')

# 離散フーリエ変換のシフト図示 floorでマイナス方向の整数に丸める
kshift = k - math.floor(len(k) / 2)                   # インデックスのシフト
Xshift = np.fft.fftshift(X)                           # 離散フーリエ変換のシフト
magXshift = np.abs(Xshift)                            # シフトされた振幅スペクトル
fig4 = plt.figure()
ax4 = fig4.add_subplot(1, 1, 1)
ax4.stem(kshift, magXshift)                           # シフトされた振幅スペクトルの図示
ax4.set_xlim(-len(k) / 2, len(k) / 2); ax4.set_ylim(0, maxX); ax4.grid()
ax4.set_xlabel('Frequency $k$')
ax4.set_ylabel("$|X[k]|$")
