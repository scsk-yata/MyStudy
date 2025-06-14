<script>
	// データを配列に用意します
	var a = [1,3,10,2,8];

	// 合計値を0に初期化します
	var sum = 0;
	// データの個数だけくり返します
	for (var i=0; i<a.length; i++) {
		// 各値を足します
		sum += a[i];
	}
	// 平均値を計算します
	average = sum / a.length;
	// 結果を表示します
	alert("平均="+average);
</script>
