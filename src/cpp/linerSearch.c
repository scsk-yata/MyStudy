#include <stdio.h>

int main(int argc, char *argv[]) {
	// 検索する配列データです
	int a[] = {10,3,1,4,2};
	// この値を探します
	int searchValue = 4;
	// 見つかったときの番号。初期値は、エラーの値（-1）にしておきます
	int findID = -1;

	// 要素の個数を調べます
	int length = sizeof(a)/sizeof(int);
	// 配列のすべての値を調べていきます
	int i;
	for (i=0; i<length; i++) {
		// 配列の値と、探す値が同じなら
		if (a[i] == searchValue) {
			// その番号を保存して、くり返しを終了します
			findID=i;
			break;
		}
	}

	// 検索結果を表示します
	printf("見つかった番号=%d",findID);
}