x = int(input('x = '))
y = int(input('y = '))

try:
    print(x // y)
except ZeroDivisionError:
    print('ゼロでは割れません')

print('ここは必ず実行される')
