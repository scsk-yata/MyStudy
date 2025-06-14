class Average {
			// javaのcomment
	public static void main(String[] args) {

		// データを配列に用意します
		int a[] = {1,3,10,2,8};
	
		// 合計値を0に初期化します
		int sum = 0;
		// データの個数だけくり返します
		for (int i=0; i<a.length; i++) {
			// 各値を足します
			sum += a[i];
		}
		// 平均値を計算します　（）でデータ型を指定
		float average = (float)sum / a.length;
		// 結果を表示します
		System.out.println("平均=" + average);
	}
}
