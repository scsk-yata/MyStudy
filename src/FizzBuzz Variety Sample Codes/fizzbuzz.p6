# FizzBuzzの値を返す関数を定義 --- (*1)
sub fizzbuzz(Int $n) {
  given [$n % 3, $n % 5] {
    when [0, 0] { "FizzBuzz" }
    when [0, *] { "Fizz" }
    when [*, 0] { "Buzz" }
    default { $n }
  }
}
# 1から100まで繰り返して表示 --- (*2)
for 1..100 { fizzbuzz($_).say };

