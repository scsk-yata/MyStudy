// FizzBuzzオブジェクトの定義 --- (*1)
object FizzBuzz {
  // mainメソッドの定義 --- (*2)
  def main(args: Array[String]) = {
    for (i <- 1 to 100) {
      println(fizzbuzz(i))
    }
  }
  // FizzBuzzの値を返すメソッドの定義 --- (*3)
  def fizzbuzz(i: Int): String = {
    var isfizz = (i % 3 == 0)
    var isbuzz = (i % 5 == 0)
    if (isfizz && isbuzz) {
      "FizzBuzz"
    } else if (isfizz) {
      "Fizz"
    } else if (isbuzz) {
      "Buzz"
    } else {
      i.toString
    }
  }
}
