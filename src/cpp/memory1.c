#include <stdio.h>

int func(x, y){
    int sum = x + y;
    return sum;
}

int main(){
    printf("%d", func(3, 5));
}
