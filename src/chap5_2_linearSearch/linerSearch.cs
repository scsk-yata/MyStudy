using System;

namespace test
{
	internal class Program
	{
		static void Main(string[] args)
		{
			// データを配列に用意します
			int[] a = new int[] {10,3,1,4,2};
			// この値を探します
			int searchValue = 4;
			// 見つかったときの番号。初期値は、エラーの値（-1）にしておきます
			int findID = -1;
			
			// 要素の個数を調べます
			int length = a.Length;
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
			
			// 値を表示します
			Console.WriteLine("見つかった番号={0} ",findID);
		}
	}
}