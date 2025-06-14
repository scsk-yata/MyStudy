#!/usr/bin/python
#-*- coding: utf-8 -*-

import math
import random

def isprime(n):              # nが素数かどうか判定する関数
    if n == 2:
        return True
    if n%2 == 0:             # 偶数は素数でない
        return False
    for i in range(3, n):
        if math.sqrt(n) < i: # nの平方根より大きい数はnの約数にならない
            return True
        if n%i == 0:         # iがnの約数(nが素数でない)
            return False

p, q = 0, 0
while (p==q) or not isprime(p) or not isprime(q):
    p = random.randint(10**5, 10**6)
    q = random.randint(10**5, 10**6)

print('p: ' + str(p))
print('q: ' + str(q))
