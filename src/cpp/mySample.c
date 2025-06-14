#include <stdio.h>
#include <stdlib.h>
#define N 123 // マクロ変数を定義

int main(void)
{ // 戻り値の型はintでもvoidでも良い
    int x[4] = {1, 2, 3, 4};
    int w[4] = {5, 6, 7, 8};
    int i, s[N], y = 0.1;

    for (i = 0; i < 4; i++)
        y += x[i] * w[i]; // ;までの処理が、繰り返しの対象。
    printf("%ld\n", y);   // doubleタイプの表示

    for (i = 0; i < N; i++)
    {
        if (rand() % 2 == 0)
            s[i] = 1;
        else
            s[i] = -1; // この書き方でも動作するが、推奨されない。
        // printf("%d番目のsの値は%d\n",(i+1),*(s+i));
        printf("%d番目のsの値は%d\n", (i + 1), s[i]);
    }
    return 0;
}