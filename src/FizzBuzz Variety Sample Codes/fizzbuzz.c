// ヘッダファイルの取り込み ---(*1)
#include<stdio.h> 

// 最初に実行されるmain関数
int main(void) {
  int i;
  for(i = 1; i <= 100; ++i) { // --- (*2)
    if (i % 3 == 0 && i % 5 == 0) { 
      printf("FizzBuzz");
    } else if (i % 3 == 0) {
      printf("Fizz");
    } else if (i % 5 == 0) {
      printf("Buzz");
    } else {
      printf("%d", i);
    }
    printf("\n");
  }
  return 0;
}

