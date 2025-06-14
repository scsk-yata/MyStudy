#include <stdio.h>

int count_space(char str[]){
    int i, count = 0;
    for (i = 0; i < strlen(str); i++)
        if (str[i] == ' ')
            count++;
    return count;
}

int main(){
    printf("%d\n", count_space("This is a pen."));
    return 0;
}
