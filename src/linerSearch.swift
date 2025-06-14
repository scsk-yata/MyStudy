// 検索する配列データです
let a = [10,3,1,4,2]
// この値を探します
let searchValue = 4;
// 見つかったときの番号。初期値は、エラーの値（-1）にしておきます
var findID = -1;

// 配列のすべての値を調べていきます
for i in 0..<a.count {
	// 配列の値と、探す値が同じなら
	if a[i] == searchValue {
		// その番号を保存して、くり返しを終了します
		findID = i
		break
	}
}

// 検索結果を表示します
print("見つかった番号=",findID);
