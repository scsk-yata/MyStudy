print('Hello Yata Masa')

def fibonacci(n):
    if(n==0) or (n==1):
        return 1
    return fibonacci(n-1) + fibonacci(n-2)

n = 10
print(fibonacci(n))