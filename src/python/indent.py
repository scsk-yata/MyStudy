import math
from operator import truediv # 分数ではなく真の値を計算する

for i in range(2,101):
    is_prime = True
    for j in range(2,int(math.sqrt(i))+1): #平方根以上は調べなくてよい
        if i % j == 0:
            is_prime = False
            break
        
    if is_prime:
        print(i)