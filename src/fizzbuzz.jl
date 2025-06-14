# FizzBuzzの値を返す関数を定義 --- (*1)
function fizzbuzz(n)
  if n % 3 == 0 && n % 5 == 0
    return "FizzBuzz"
  elseif n % 3 == 0
    return "Fizz"
  elseif n % 5 == 0
    return "Buzz"
  else
    return n
  end
end

# 繰り返し関数を実行 --- (*2)
for i = 1:100
  println(fizzbuzz(i))
end

