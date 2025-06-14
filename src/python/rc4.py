#!/usr/bin/python
#-*- coding: utf-8 -*-

import sys

def KSA(K):
    S = list(range(256))
    j = 0
    for i in range(256):
        j += S[i] + K[i % len(K)]
        j %= 256
        S[i], S[j] = S[j], S[i]
    return S

def PRGA(S, text):
    j = 0
    Z = []
    for i in range(1, len(text)+1):
        i %= 256
        j = (j + S[i]) % 256
        S[i], S[j] = S[j], S[i]
        Z.append(S[(S[i]+S[j]) % 256])
    return Z

def RC4(key, text):
    key = list(key)
    text = list(text)
    S = KSA(key)
    Z = PRGA(S, text)
    out = [text[i] ^ Z[i] for i in range(len(text))]
    return out

if __name__=='__main__':
    f_key = open(sys.argv[1], 'rb')
    f_txt = open(sys.argv[2], 'rb')
    key  = f_key.read()
    text = f_txt.read()
    
    output = RC4(key, text)
    f_out = open('output.dat', 'wb')
    f_out.write(bytearray(output))
    
    f_key.close()
    f_txt.close()
    f_out.close()
