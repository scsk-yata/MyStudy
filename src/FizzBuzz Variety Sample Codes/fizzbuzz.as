class FizzBuzz {
  // FizzBuzzを返す関数を定義 --- (*1)
  static function fizzbuzz(n:Number): String {
    if (n % 3 == 0 && n % 5 == 0) return "FizzBuzz";
    if (n % 3 == 0) return "Fizz";
    if (n % 5 == 0) return "Buzz";
    return String(n);
  }
  // メイン関数 --- (*2)
  static function main() {
    // 100回fizzbuzz関数を呼び出す
    for (var i:Number = 1; i <= 100; i++) {
      trace(FizzBuzz.fizzbuzz(i));
    }
  }
}
