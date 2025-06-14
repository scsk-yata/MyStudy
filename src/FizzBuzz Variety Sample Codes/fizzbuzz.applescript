-- FizzBuzzを返す関数の定義 --- (*1)
on fizzbuzz(i)
    if i mod 15 is 0 then
        return "FizzBuzz"
    else if i mod 3 is 0 then
        return "Fizz"
    else if i mod 5 is 0 then
        return "Buzz"
    else
        return i as string
    end if
end fizzbuzz

-- 100回fizzbuzz関数を呼び出す --- (*2)
set res to ""
repeat with i from 1 to 100
    set res to res & fizzbuzz(i) & "\n"
end repeat

