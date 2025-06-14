using System;

namespace test
{
	internal class Program
	{
		static void Main(string[] args)
		{
			// データを配列に用意します
			int[] a = new int[] {1,3,10,2,8};
			
			// 合計値を0に初期化します
			int sum = 0;
			// 要素の個数を調べます
			int length = a.Length; 
			// データの個数だけくり返します
			int i;
			for (i=0; i<length; i++) {
				// 各値を足します
				sum += a[i];
			}
			
			// 値を表示します
			Console.WriteLine("合計={0} ",sum);
		}
	}
}
