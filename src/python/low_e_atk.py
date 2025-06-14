#!/usr/bin/python
#-*- coding: utf-8 -*-

import sys

def decrypt(cipher, e):
    plain = []

    for c in cipher:
        m = int(round(c**(1.0/e))) # 四捨五入してint型に変換
        plain.append(chr(m))       # chr()で文字に変換
    return ''.join(plain)

if __name__=='__main__':
    cipher = [373248, 1030301, 1259712, 1259712, 1367631, 1000] # 計算した暗号文
    e = int(sys.argv[1])

    result = decrypt(cipher, e)

    print('plain text:')
    print(str(result)),
