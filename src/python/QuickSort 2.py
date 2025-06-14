# -*- coding: utf-8 -*-

# 《 クイックソート関数 》
def quickSort(data):
    # データの個数が１個以下ならそのまま返します
    if len(data) <= 1:
        return data
    # 真ん中の位置にある値を［ピボット］にします
    pivot = data[ int((len(data) - 1) / 2)]
    # 左右の配列を空っぽにします
    left = []
    right = []
    # pivotより小さければleftに、大きければrightに追加します    
    for i in range(0,len(data)):
        if data[i] < pivot:
            left.append(data[i])
        elif data[i] > pivot:
            right.append(data[i])
    # 分割した結果をさらにクイックソートします
    left = quickSort(left)
    right = quickSort(right)
    # 左の結果、真ん中のpivot、右の結果を足した配列を返します
    return left +[pivot] + right

# 《 クイックソートを行います 》
# ソート前の配列データです
a = [10,3,1,9,7,6,8,2,4,5]

# 先頭から末尾までソートします
sortdata = quickSort(a)

# ソート後の配列を表示します
print("ソート後=",sortdata)