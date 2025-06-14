// FizzBuzzクラスを定義 --- (*1)
class FizzBuzz {
  static function main():Void {
    // 1から100まで繰り返す --- (*2)
    for (i in 1...101) {
      var result = getNumber(i);
      trace(result);
    }
  }
  // FizzBuzzの条件によって返す関数 --- (*3)
  static function getNumber(i:Int): String {
    if (isFizz(i) && isBuzz(i)) return "FizzBuzz";
    if (isFizz(i)) return "Fizz";
    if (isBuzz(i)) return "Buzz";
    return Std.string(i);
  }
  static function isFizz(i:Int):Bool return i % 3 == 0;
  static function isBuzz(i:Int):Bool return i % 5 == 0;
}
