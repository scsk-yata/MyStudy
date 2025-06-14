<script>
	// ソート前の配列データです
	var a = [10,3,1,9,7,6,8,2,4,5];

	// 「グループ分けの間隔」を半分にしていくくり返し
	for(var step=parseInt(a.length/2); step>0; step=parseInt(step/2)) {
		// ［　間隔を開けて挿入ソート　］
		// 「挿入する値」を順番に１つずつ取り出すくり返し
		for (var i=step; i<a.length; i++) {
			// 「挿入する値」を、変数に入れて待避します
			var tmp = a[i];
			// 取り出した位置から前に向かって比較をくり返します
			for(var j=i; j>=step;j-=step) {
				if (a[j-step] > tmp) {
					// もし「挿入する値」が小さければ、その値をstep幅だけ後ろへずらします
					a[j] = a[j-step];
				} else {
					// もし「挿入する値」が小さくなければ、そこでずらす処理を止めます
					break;
				}
			}
			// ずらす処理が終わったところに「挿入する値」を入れます
			a[j] = tmp;
		}
	}

	// ソート後の配列を表示します
	alert("ソート後="+a);
</script>