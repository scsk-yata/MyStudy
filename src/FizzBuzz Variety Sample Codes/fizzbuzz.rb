# FizzBuzzに応じた値を返す関数 --- (*1)
def fizzbuzz(i)
  if i % 3 == 0 and i % 5 == 0
    "FizzBuzz"
  elsif i % 3 == 0
    "Fizz"
  elsif i % 5 == 0
    "Buzz"
  else
    i
  end
end

# 1から100まで繰り返しfizzbuzzを呼ぶ --- (*2)
1.upto(100) do |i|
  puts fizzbuzz(i)
end

