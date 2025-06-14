// メイン関数の定義 --- (*1)
fun main(args: Array<String>) {
  for (i in 1..100) { // 1から100まで繰り返す --- (*2)
    var res = fizzbuzz(i)
    System.out.println(res)
  }
}
// FizzBuzzの値を返す関数の定義 --- (*3)
fun fizzbuzz(i: Int): String {
  return when { // when構文で順次条件を判定 --- (*4)
    i % 3 == 0 && i % 5 == 0 -> "FizzBuzz"
    i % 3 == 0 -> "Fizz"
    i % 5 == 0 -> "Buzz"
    else -> i.toString()   
  }
}

