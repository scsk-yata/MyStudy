#include<stdio.h>
#include<stdlib.h>
#define N 100

int main(void){ // 戻り値の型はvoidでも良い。
    int i, s[N];
    for(i=0; i<N; i++){
        if(rand()%2==0) s[i] = 1;
        else s[i] = -1; // 条件分岐の処理が一行なら改行せずに記述できる
        printf("%d番目のsの値は%d\n", (i+1), *(s+i)); // sは配列の先頭アドレス
    }
    return 0;
}