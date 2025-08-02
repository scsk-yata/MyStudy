#include<stdlib.h>
#include<stdio.h>
int main(void){
    int *p, i; // 確保されたint型×10のメモリの先頭アドレス
    p = malloc(sizeof(int)*10);
    printf("i = %d\n",(int)i);
    for(i=0;i<10;i++)
        *(p+i)=2*i;
    free(p); // 確保されたメモリの開放
    return 0;
}
