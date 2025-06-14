def count_space(str):
    count = 0
    for i in range(len(str)):
        if str[i] == ' ':
            count += 1
    return count

print(count_space("This is a pen."))
