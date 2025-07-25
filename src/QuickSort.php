<?php
	// 《 クイックソート関数 》
	function quickSort($startID,$endID) {
		// 関数の中から配列を扱えるようにします。
		global $a;
		// 真ん中の位置にある値を［ピボット］にします
		$pivot = $a[(int)(($startID + $endID) / 2)];
		// 調べる［左］の位置を初期値します
		$left = $startID;
		// 調べる［右］の位置を初期値します
		$right = $endID;

		// 《 ピボットより小さい値を左側へ、大きい値を右側へ分割します 》
		while (true) {
			// ［左］の値がピボットより小さければ、［左］を１つ右へ進めます
			while ($a[$left] < $pivot) {
				$left++;
			}
			// ［右］の値がピボットより大きければ、［右］を１つ左へ進めます
			while ($pivot < $a[$right]) {
				$right--;
			}
			// ［右］と［左］がぶつかったら、そこで分割終了です
			if ($right <= $left){
				break;
			}
			// ぶつかっていなければ
			// ［左］の値と、［右］の値を交換します
			$tmp = $a[$left];
			$a[$left] = $a[$right];
			$a[$right] = $tmp;
			// ［左］を１つ右へ進めます
			$left++;
			// ［右］を１つ左へ進めます
			$right--;
		}
		// もし左側に分割するデータがあったら
		if ($startID < $left-1) {
			// 左側のデータを同じように分割します
			quickSort($startID,$left-1);
		}
		// もし右側に分割するデータがあったら
		if ($right+1 < $endID) {
			// 右側のデータを同じように分割します
			quickSort($right+1,$endID);
		}
	}

	// 《 クイックソートを行います 》
	// ソート前の配列データです
	$a = array(10,3,1,9,7,6,8,2,4,5);

	// 先頭から末尾までソートします
	quickSort(0, count($a)-1);

	// ソート後の配列を表示します
	print_r($a);

?>