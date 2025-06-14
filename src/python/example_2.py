# プログラム例
print('ライプニッツの公式による π の近似値')
N = 10**7
S = 0
for n in range(0, N + 1):
    p = 1 / (2 * n + 1) 
    S = S + (-1)**n * p
pi = 4 * S
print('pi= \n',pi)