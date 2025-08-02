#include <stdio.h>

#define SIZE 10  // 配列サイズをマクロで定義

/**
 * @brief  配列に 2*i を代入し、内容を表示する
 * @return 成功時は 0 を返す
 */
int main(void) {
    int a[SIZE] = {0}; // 配列の初期化（オールゼロ）

    // 配列に値を格納
    for (int i = 0; i < SIZE; i++) {
        a[i] = 2 * i;
        // *(a+i)=2*i;

    }

    // 配列の内容を表示
    printf("Array: ");
    for (int i = 0; i < SIZE; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");

    return 0;
}
