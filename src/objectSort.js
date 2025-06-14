<script>
	// ソート前の配列データです
	a = [];
 	// 名前と点数をまとめたオブジェクトを追加していきます	
	a.push({name:"A", score:10});
	a.push({name:"B", score:30});
	a.push({name:"C", score:100});
	a.push({name:"D", score:80});
	a.push({name:"E", score:70});

	// 調べる範囲の開始位置を１つずつ後ろへ移動していくくり返し
	for (i=0; i<a.length; i++) {
		// 後ろから前に向かって小さい値を浮かび上がらせるくり返し
		for (j=a.length-1; j>i; j--) {
			// // 隣り合う２つのscore値のうち、後ろの方の値が大きかったら
			if (a[j].score > a[j-1].score) {
				// オブジェクトを交換して、前に移動します
				tmp = a[j];
				a[j] = a[j-1];
				a[j-1] = tmp;
			}
		}
	}

	// 結果を表示します
	document.write("ソート後=");
	for (i=0;i<a.length;i++) {
		document.writeln(a[i].name+":"+a[i].score);
	}
</script>