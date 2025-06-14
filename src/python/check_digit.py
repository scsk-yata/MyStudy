def check_digit(isbn):
    sum = 0
    for i in range(len(isbn)-1): # 0から12番目まで
        if i % 2 == 0:
            sum += int(isbn[i])
            print('i : %i' %(i)) # %を使う場合は，いらない
            print(sum)
        else:
            sum += int(isbn[i]) * 3
            print('i : %i' %(i))
            print(sum)
    if (sum % 10) != 0:
        return 10 - (sum % 10)
    else:
        return 0

#print('check_digit(9784798163284)')
print(check_digit('9784798163284'))
#print(str(check_digit('9784798163284')))
#print(check_digit('1111'))