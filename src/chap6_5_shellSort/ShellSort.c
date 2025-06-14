#include <stdio.h>

int main(int argc, char *argv[]) {
	// ソート前の配列データです
	int a[] = {10,3,1,9,7,6,8,2,4,5};

	// 要素の個数を調べます
	int length = sizeof(a)/sizeof(int);
	// 「グループ分けの間隔」を半分にしていくくり返し
	int step,i,j;
	for(step=length/2; step>0; step/=2) {
		// ［　間隔を開けて挿入ソート　］
		// 配列から順番に１つずつ「挿入する値」を取り出すことをくり返します
		for (i=step; i<length; i++) {
			// 「挿入する値」を、変数に入れて待避します
			int tmp = a[i];
			// 取り出した位置から前に向かって比較をくり返します
			int j=i;
			for (j=i; j>=step; j-=step) {
				if (a[j-step] > tmp) {
					// もし「挿入する値」が小さければ、その値をstep幅だけ後ろへずらします
					a[j] = a[j-step];
				} else {
					// もし「挿入する値」が小さくなければ、そこでずらす処理を止めます
					break;
				}
			}
			// ずらす処理が終わったところに「挿入する値」を入れます
			a[j] = tmp;
		}
			
	}

	// ソート後の配列を表示します
	for (i=0;i<length;i++) {
		printf("%d ",a[i]);
	}
}