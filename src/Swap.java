class Swap {
			
	public static void main(String[] args) {

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

		// 結果を表示します
		System.out.println("a="+a+",b="+b);
	}
}
