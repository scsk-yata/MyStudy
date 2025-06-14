#!/usr/bin/python
#-*- coding: utf-8 -*-

from aes_functions import key_schedule
from aes_functions import AddRoundKey
from aes_functions import SubBytes
from aes_functions import ShiftRows
from aes_functions import MixColumns
import numpy as np
import sys

def encrypt_1block(key, text):
    roundkeys = key_schedule(key)
    roundkeys = np.array([rk.reshape(4, 4).T for rk in roundkeys])
    text = text.reshape(4, 4).T

    out = AddRoundKey(text, roundkeys[0])
    for i in range(1, 10):
        out = SubBytes(out)
        out = ShiftRows(out)
        out = MixColumns(out)
        out = AddRoundKey(out, roundkeys[i])
    out = SubBytes(out)
    out = ShiftRows(out)
    out = AddRoundKey(out, roundkeys[-1])
    return list(out.T.reshape(16,))

def encrypt(key, text):
    import hashlib
    iv = hashlib.md5(key+b'key').digest()
    iv = list(iv)

    key = np.array(list(key))
    text = [text[i:i+16] for i in range(0, len(text), 16)]
    cipher = iv

    last_result = np.array(iv)
    for t in text:
        t = np.array(list(t))
        last_result = encrypt_1block(key, last_result^t)
        cipher += last_result
    return cipher

if __name__=='__main__':
    f_key = open(sys.argv[1], 'rb')
    f_txt = open(sys.argv[2], 'rb')
    key  = f_key.read()
    text = f_txt.read()

    output = encrypt(key, text)
    f_out = open('output.dat', 'wb')
    f_out.write(bytearray(output))

    f_key.close()
    f_txt.close()
    f_out.close()
