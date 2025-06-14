#include<stdio.h>
int main(void) {
    int c = 2;
    int *p;
    p = &c;
    printf("cのアドレスは%p.\n",p); // ポインタを表示するには文字列の中に%p
    printf("cのアドレスは%p.\n",&c);
    printf("ポインタpが指すメモリの中の値は%d.\n",*p);
    printf("変数cの値は%d.\n",c);
    return 0;
}