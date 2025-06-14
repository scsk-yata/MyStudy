<?php
// 1から100までfizzbuzz関数を実行 --- (*1)
for ($i = 1; $i <= 100; $i++) {
  $result = fizzbuzz($i);
  echo $result."\n";
}
// FizzBuzzの結果を返す関数 --- (*2)
function fizzbuzz($i) {
  if ($i % 3 == 0 && $i % 5 == 0) return "FizzBuzz";
  if ($i % 3 == 0) return "Fizz";
  if ($i % 5 == 0) return "Buzz";
  return $i;
}
