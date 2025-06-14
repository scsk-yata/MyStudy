# -*- coding: utf-8 -*-

# データを配列に用意します
a = [1,3,10,2,8]

# 合計値を0に初期化します
sum = 0
# データの個数だけくり返します
for i in range(len(a)):
	# 各値を足します
	sum += a[i]

# 平均値を計算します
average = sum / len(a)
# 結果を表示します
print("平均=",average)
