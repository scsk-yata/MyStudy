#!/usr/bin/python
#-*- coding: utf-8 -*-

import sys

def gen_public_key(p, q):
    e = 65537
    n = p*q
    return e, n

def encrypt(text):
    p, q = 513131, 248021
    e, n = gen_public_key(p, q)
    text = list(text)
    cipher = []
    
    for t in text:
        c = pow(t, e, n)          # pow(t, e, n) = t**e mod n
        cipher.append(c)
    return cipher

if __name__=='__main__':
    f_txt = open(sys.argv[1], 'rb')
    text = f_txt.read()
    f_txt.close()
    
    result = encrypt(text)
    print('cipher:')
    print(result)
