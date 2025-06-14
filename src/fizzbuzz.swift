// FizzBuzzの値を返す関数 --- (*1)
func fizzbuzz(i:Int) -> String {
  if i % 3 == 0 && i % 5 == 0 { return "FizzBuzz" }
  if i % 3 == 0 { return "Fizz" }
  if i % 5 == 0 { return "Buzz" }
  return String(i)
}
// 1から100まで繰り返し関数を呼ぶ --- (*2)
for num in 1...100 {
  print(fizzbuzz(i:num)) // --- (*3)
}



