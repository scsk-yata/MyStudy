import numpy as np
import wave
import matplotlib.pyplot as plt
import scipy.signal as sig
import scipy
#import commpy

bits = np.random.randint(0, 2, 16384) # 0or1
rate = 9600.0           # Samples per second
targetrate = rate * 15   # Upsampling target rate

if __name__ == "__main__": # メインコードとして実行されたときのみ
    # BPSK変調
    bpsk_mod = bits*2 - 1.0 # -1 or +1に振り分け
    # 16QAM変調
    qpsk_mod = bpsk_mod[::4]+bpsk_mod[1::4]*1.0j # 4個刻み 長さはbpsk_modの1/4にしている
    _16qam_mod = qpsk_mod + bpsk_mod[2::4]*2.0 + bpsk_mod[3::4]*2.0j
    _16qam_mod = _16qam_mod*(1.0/np.sqrt(2.0)/3.0) # 端のシンボルの振幅を正規化
    # AWGNノイズを付加
    #_16qam_modN = commpy.awgn(_16qam_mod, 15, 1)
    # 16QAMコンスタレーション表示
    plt.figure()
    #plt.scatter(_16qam_modN.real, _16qam_modN.imag, lw=0.3, color="blue")
    plt.scatter(_16qam_mod.real, _16qam_mod.imag, lw=0.3, color="red")
    plt.show()