<script>
	// ソート前の配列データです
	var a = [10,3,1,4,2];

	// 「最小値を入れる位置」を、先頭から順番に選択していくくり返し
	for (var i=0; i<a.length-1; i++) {
		// ［　最小値を探すアルゴリズム　］
		// まず、先頭の値を暫定の最小値として初期化します
		var min = a[i];
		// 先頭の位置も保存しておきます
		var k = i;
		// 隣の位置から最後まで、最小値との比較をくり返します
		for (var j=i+1; j<a.length; j++){
			// もし最小値よりも小さい値が見つかったら
			if (min > a[j]) {
				// 最小値を上書きして
				min = a[j];
				// その位置を保存しておきます
				k = j;
			}
		}
		// ［　交換するアルゴリズム　］
		// 「先頭の値」と「最小値の値」を交換します
		var tmp = a[i];
		a[i] = a[k];
		a[k] = tmp;
	}

	// ソート後の配列を表示します
	alert("ソート後="+a);
</script>