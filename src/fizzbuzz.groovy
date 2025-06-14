// FizzBuzz関数の定義 --- (*1)
def fizzbuzz(i) {
  // FizzとBuzzを判定するクロージャを定義 --- (*2)
  Closure isFizz = { it % 3 == 0 }
  Closure isBuzz = { it % 5 == 0 }
  // 順次判定する --- (*3)
  if (isFizz(i) && isBuzz(i)) {
    return "FizzBuzz"
  } else if (isFizz(i)) {
    return "Fizz"
  } else if (isBuzz(i)) {
    return "Buzz"
  } else {
    return i
  }
}

// 100回、fizzbuzz関数を呼び出す --- (*4)
for (i in 1..100) {
  println fizzbuzz(i)
}

