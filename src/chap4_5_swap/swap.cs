using System;

namespace test
{
	internal class Program
	{
		static void Main(string[] args)
		{
			// 交換前のデータです
			int a = 10;
			int b = 20;
			int t;
			
			// tに、aの値を入れて待避させます
			t = a;
			// aに、bの値を入れます
			a = b;
			// bに、待避させたtの値を入れます
			b = t;
			
			// 値を表示します
			Console.WriteLine("a={0},b={1} ",a,b);
		}
	}
}
