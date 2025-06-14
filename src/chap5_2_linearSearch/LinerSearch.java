class LinerSearch {
	
	public static void main(String[] args) {
			
		// 検索する配列データです
		int a[] = {10,3,1,4,2};
		// この値を探します
		int searchValue = 4;
		// 見つかったときの番号。初期値は、エラーの値（-1）にしておきます
		int findID = -1;

		// 配列のすべての値を調べていきます
		for (int i=0; i<a.length; i++) {
			// 配列の値と、探す値が同じなら
			if (a[i] == searchValue) {
				// その番号を保存して、くり返しを終了します
				findID = i;
				break;
			}
		}
	
		// 検索結果を表示します
		System.out.println("見つかった番号="+findID);
	}
}