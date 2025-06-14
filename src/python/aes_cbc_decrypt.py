#!/usr/bin/python
#-*- coding: utf-8 -*-

from aes_functions import key_schedule
from aes_functions import AddRoundKey
from aes_functions import invSubBytes
from aes_functions import invShiftRows
from aes_functions import invMixColumns
import numpy as np
import sys

def decrypt_1block(key, enc):
    roundkeys = key_schedule(key)
    roundkeys = np.array([rk.reshape(4, 4).T for rk in roundkeys])
    enc = enc.reshape(4, 4).T

    out = AddRoundKey(enc, roundkeys[-1])
    out = invShiftRows(out)
    out = invSubBytes(out)
    for i in range(1, 10)[::-1]:
        out = AddRoundKey(out, roundkeys[i])
        out = invMixColumns(out)
        out = invShiftRows(out)
        out = invSubBytes(out)
    out = AddRoundKey(out, roundkeys[0])
    return list(out.T.reshape(16,))

def decrypt(key, data):
    key = np.array(list(key))
    data = [data[i:i+16] for i in range(0, len(data), 16)]  # split per 16 byte
    plain = []

    last_result = np.array(list(data[0])) # data[0] : iv
    for d in data[1:]:
        d = np.array(list(d))
        plain += list(np.array(decrypt_1block(key, d)) ^ last_result)
        last_result = d
    return plain

if __name__=='__main__':
    f_key = open(sys.argv[1], 'rb')
    f_enc = open(sys.argv[2], 'rb')
    key = f_key.read()
    enc = f_enc.read()
    
    output = decrypt(key, enc)
    f_out = open('output.dat', 'wb')
    f_out.write(bytearray(output))
    
    f_key.close()
    f_enc.close()
    f_out.close()
