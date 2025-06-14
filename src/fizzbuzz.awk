# FizzBuzzの値を返す関数 --- (*1)
function fizzbuzz(i) {
  if (i % 3 == 0 && i % 5 == 0) return "FizzBuzz"
  if (i % 3 == 0) return "Fizz"
  if (i % 5 == 0) return "Buzz"
  return i
}

# 最初に実行する部分 --- (*2)
BEGIN {
  for (i = 1; i <= 100; i++) {
    print fizzbuzz(i)
  }
}

