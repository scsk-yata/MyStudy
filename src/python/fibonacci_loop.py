n=11
fibonacci = [0]*n
fibonacci[0] = 1
fibonacci[1] = 1
for i in range(2,n):
    fibonacci[i] = fibonacci[i-1] + fibonacci[i-2]
    
print(fibonacci[-1]) #インデックス-1が最後の値