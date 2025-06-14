import numpy as np # NumPyを使う
# 1から100までの連続する配列を生成 --- (*1)
nums = np.arange(1, 101)
# FizzBuzzの条件リストを指定 --- (*2)
cond_list = [nums % 15 == 0, nums % 3 == 0, nums % 5 == 0, True]
# 条件に合致した時の値を指定 --- (*3)
value_list = ["FizzBuzz", "Fizz", "Buzz", nums]
# 条件ごとに値を設定する --- (*4)
result = np.select(cond_list, value_list)
# 結果を出力
print("\n".join(result))

