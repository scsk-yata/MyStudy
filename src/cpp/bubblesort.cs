using System;

namespace test
{
	internal class Program
	{
		static void Main(string[] args)
		{
			// ソート前の配列データです
			int[] a = new int[] {10,3,1,4,2};
			
			// 要素の個数を調べます
			int length = a.Length;
			// 調べる範囲の開始位置を１つずつ後ろへ移動していくくり返し
			int i,j;
			for (i=0; i<length-1; i++) {
				// 後ろから前に向かって小さい値を浮かび上がらせるくり返し
				for (j=length-1; j>i; j--) {
					// 隣り合う２つの、後ろの方の値が小さかったら
					if (a[j] < a[j-1]) {
						// 交換して、前に移動します
						int tmp = a[j];
						a[j] = a[j-1];
						a[j-1] = tmp;
					}
				}
			}
			
			// ソート後の配列を表示します
			for (i=0;i<length;i++) {
				Console.Write("{0} ", a[i]);
			}
		}
	}
}
