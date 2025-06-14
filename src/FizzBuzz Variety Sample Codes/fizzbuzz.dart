// Fizzかどうかを判定する関数 --- (*1)
isFizz(int i) { return i % 3 == 0; }
// Buzzかどうかを判定する関数
isBuzz(int i) { return i % 5 == 0; }
// FizzBuzzに応じた値を返す --- (*2)
fizzbuzz(int i) {
  if (isFizz(i) && isBuzz(i)) return "FizzBuzz";
  if (isFizz(i)) return "Fizz";
  if (isBuzz(i)) return "Buzz";
  return i;
}
// 最初に実行する関数 --- (*3)
main() {
  // 1から100まで繰り返す --- (*4)
  for (var i = 1; i <= 100; i++) {
    var result = fizzbuzz(i);
    print(result);
  }
}
