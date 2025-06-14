# 階乗の再帰的定義

def myfact(n): # factorial
    if n == 0:
        return 1
    else:
        return n*myfact(n-1)