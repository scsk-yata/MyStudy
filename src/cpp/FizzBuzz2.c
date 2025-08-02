#include<stdio.h> 
// defineでマクロ関数を定義
#define IS_FIZZ(i) (i % 3 == 0)
#define IS_BUZZ(i) (i % 5 == 0)

char buf[256];

// FizzBuzzを返す関数を定義 文字列の配列を返す　fizz-buzzという関数名
char* fizzbuzz(int i) {
  // 関数を使って条件を次々と判定し、一番最初に該当したif文のみreturn実行
  if (IS_FIZZ(i) && IS_BUZZ(i)) return "FizzBuzz";
  if (IS_FIZZ(i)) return "Fizz";
  if (IS_BUZZ(i)) return "Buzz";
  sprintf(buf, "%d", i); // iを%dで指定したフォーマットでbufに保存する
  return buf; // fizz buzz番号も返す
}

// メイン関数
int main(void) {
  // 繰り返しfizz_buzz関数を呼び出す
  int i;
  for(i = 1; i <= 100; ++i) {
    printf("%s\n", fizzbuzz(i)); // %sで文字配列指定　\nで改行
  }
  return 0;
}