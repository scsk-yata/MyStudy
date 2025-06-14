# モジュールを定義 --- (*1)
defmodule FizzBuzz do
  # FizzBuzzを返す関数を定義 --- (*2)
  def getValue(i) do
    cond do
      Integer.mod(i, 15) == 0 -> "FizzBuzz"
      Integer.mod(i, 3)  == 0 -> "Fizz"
      Integer.mod(i, 5)  == 0 -> "Buzz"
      :else                   -> i
    end
  end
end
# 100回繰り返す --- (*3)
for i <- 1..100 do
  IO.puts FizzBuzz.getValue(i)
end

 
