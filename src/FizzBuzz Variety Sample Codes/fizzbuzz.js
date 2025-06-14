'use strict';
// 1から100まで繰り返す --- (*1)
for (var i = 1; i <= 100; i++) {
  console.log(fizzbuzz(i));
}
// FizzBuzzの条件によって返す関数 --- (*2)
function fizzbuzz(i) {
  // 条件に合致するか調べる
  if (i %  3 == 0 && i % 5 == 0) return "FizzBuzz";
  if (i % 3 == 0) return "Fizz";
  if (i % 5 == 0) return "Buzz";
  // その他の場合
  return i;
}

