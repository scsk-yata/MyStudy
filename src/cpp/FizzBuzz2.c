#include<stdio.h> 

// マクロを定義 --- (*1)
#define IS_FIZZ(i) (i % 3 == 0)
#define IS_BUZZ(i) (i % 5 == 0)

// 変数の定義 --- (*2)
char buf[256];

// FizzBuzzを返す関数を定義 --- (*3)
char* fizzbuzz(int i) {
  // 条件を次々と判定する
  if (IS_FIZZ(i) && IS_BUZZ(i)) return "FizzBuzz";
  if (IS_FIZZ(i)) return "Fizz";
  if (IS_BUZZ(i)) return "Buzz";
  sprintf(buf, "%d", i);
  return buf;
}

// メイン関数 --- (*4)
int main(void) {
  // 繰り返しfizzbuzz関数を呼び出す
  int i;
  for(i = 1; i <= 100; ++i) {
    printf("%s\n", fizzbuzz(i));
  }
  return 0;
}

