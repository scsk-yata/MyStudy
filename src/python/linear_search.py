def linear_search(data, value):
    # 先頭から順にループして探す
    for i in range(len(data)):
        if data[i] == value:
            # 欲しい値が見つかったら位置を返す
            return i

    # 欲しい値が見つからなかったら-1 を返す
    return -1

data = [50, 30, 90, 10, 20, 70, 60, 40, 80]
print(linear_search(data, 40))
