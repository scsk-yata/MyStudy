# FizzBuzz関数を宣言 --- (*1)
def fizzbuzz(i):
    # 一つずつ条件を確認 --- (*2)
    if i % 3 == 0 and i % 5 == 0:
        return "FizzBuzz"
    if i % 3 == 0:
        return "Fizz"
    if i % 5 == 0:
        return "Buzz"
    # その他
    return str(i)

# 100回fizzbuzz関数を呼ぶ --- (*3)
for i in range(1, 101):
    print(fizzbuzz(i))



