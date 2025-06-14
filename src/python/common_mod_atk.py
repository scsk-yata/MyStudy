#!/usr/bin/python
#-*- coding: utf-8 -*-

def ex_gcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        gcd, x, y = ex_gcd(b%a, a)
        return (gcd, y - int(b/a) * x, x) # gcd(a, b), x, yの順

def decrypt(c1, c2, e1, e2, N):
    _, s1, s2 = ex_gcd(e1, e2)
    
    # s1またはs2が負の時, pow(c1, s1, N)が計算できないため, 代わりにモジュラ逆数を使う.
    # モジュラ逆数は拡張ユークリッドの互除法で求められる
    if s1 < 0:
        _, c1, _ = ex_gcd(c1, N) # c1のモジュラ逆数を計算
    elif s2 < 0:
        _, c2, _ = ex_gcd(c2, N) # c2のモジュラ逆数を計算
    
    m1 = pow(c1, abs(s1), N)
    m2 = pow(c2, abs(s2), N)
    m = (m1 * m2) % N
    
    return chr(m)

if __name__=='__main__':
    # 必要なパラメータ
    m = ord('H')
    e1, e2 = 65537, 10007
    p, q = 513131, 248021
    N = p*q
    c1 = pow(m, e1, N)
    c2 = pow(m, e2, N)
    
    result = decrypt(c1, c2, e1, e2, N)
    print('plain text: ' + str(result))
