#include<stdio.h>
#include<stdlib.h>
int main(void){
    int k;
    FILE *fp;
    fp = fopen("testFile.txt","w");
    if(fp==NULL){
        printf("Error:ファイルを開けません\n");
        exit(1);
    } else {
        for(k=0;k<10;k++)
        fprintf(fp,"%d ",k);
    }
    fclose(fp);
    return 0;
}
