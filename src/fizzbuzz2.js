'use strict';
// 最初に1から100までの配列(Array)を生成 --- (*1)
const nums = [...Array(100 + 1).keys()].slice(1);

// アロー関数でFizzとBuzzの条件を定義 --- (*2)
const isFizz = n => n % 3 == 0, isBuzz = n => n % 5 == 0;

// FizzBuzzの条件によって返す関数 --- (*3)
function getFizzBuzz(i) {
  if (isFizz(i) && isBuzz(i)) return "FizzBuzz";
  if (isFizz(i)) return "Fizz";
  if (isBuzz(i)) return "Buzz";
  return i;
}

// 配列numsの各要素にmapでFizzBuzz関数を適用し、さらにforEachで表示 --- (*4)
nums.map(v => getFizzBuzz(v)).forEach((v, i) => console.log(v));

