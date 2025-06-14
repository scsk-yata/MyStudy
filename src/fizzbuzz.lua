-- FizzBuzzを返す関数を定義 --- (*1)
function fizzbuzz(i)
  -- 無名関数を定義 --- (*2)
  is_fizz = function (i) return i % 3 == 0 end
  is_buzz = function (i) return i % 5 == 0 end
  -- 順に条件を判定 --- (*3)
  if is_fizz(i) and is_buzz(i) then
    return "FizzBuzz"
  elseif is_fizz(i) then
    return "Fizz"
  elseif is_buzz(i) then 
    return "Buzz"
  end
  return i
end

-- 1から100まで繰り返す --- (*4)
for i = 1, 100 do
  print(fizzbuzz(i))
end

