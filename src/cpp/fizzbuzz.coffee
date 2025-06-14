# FizzBuzzの条件に応じた値を返す関数 --- (*1)
fizzbuzz = (i) ->
  if i % 3 is 0 and i % 5 is 0 then "FizzBuzz"
  else if i % 3 is 0 then "Fizz"
  else if i % 5 is 0 then "Buzz"
  else i

# 1から100まで繰り返す --- (*2)
console.log fizzbuzz i for i in [1..100]

