#include <stdio.h>

int main(int argc, char *argv[]) {
	
	// データを配列に用意します
	int a[] = {1,3,10,2,8};
	
	// 最大値に最初の値を入れて初期化します
	int max = a[0];
	// 要素の個数を調べます
	int length = sizeof(a)/sizeof(int);
	// 2つ目から最後まで、くり返します
	int i;
	for (i=1; i<length; i++) {
		// もし最大値よりも値が大きければ
		if (max < a[i]) {
			// 最大値を値で上書きします
			max = a[i];
		}
	}
	// 結果を表示します
	printf("最大値=%d",max);
}
