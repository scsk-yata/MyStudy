#include <stdio.h>

int func(n){
    char *str;
    str = (char *)malloc(n);
    return n;
}

int main(){
    printf("%d", func(3));
}
