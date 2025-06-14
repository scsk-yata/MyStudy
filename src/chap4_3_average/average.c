#include <stdio.h>

int main(int argc, char *argv[]) {
	
	// データを配列に用意します
	int a[] = {1,3,10,2,8};
	
	// 合計値を0に初期化します
	int sum = 0;
	// 要素の個数を調べます
	int length = sizeof(a)/sizeof(int);
	// データの個数だけくり返します
	int i;
	for (i=0; i<length; i++) {
		// 各値を足します
		sum += a[i];
	}
	// 平均値を計算します
	float average = (float)sum / length;

	// 結果を表示します
	printf("平均=%f ",average);
}
