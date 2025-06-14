class QuickSortClass {
		
	// 《 クイックソート関数 》
	public static void quickSort(int a[], int startID, int endID) {
		// 真ん中の位置にある値を［ピボット］にします
		int pivot = a[(int)((startID + endID) / 2)];
		// 調べる［左］の位置を初期値します
		int left = startID;
		// 調べる［右］の位置を初期値します
		int right = endID;

		// 《 ピボットより小さい値を左側へ、大きい値を右側へ分割します 》
		while (true) {
			// ［左］の値がピボットより小さければ、［左］を１つ右へ進めます
			while (a[left] < pivot) {
				left++;
			}
			// ［右］の値がピボットより大きければ、［右］を１つ左へ進めます
			while (pivot < a[right]) {
				right--;
			}
			// ［右］と［左］がぶつかったら、そこで分割終了です
			if (right <= left){
				break;
			}
			
			// ぶつかっていなければ
			// ［左］の値と、［右］の値を交換します
			int tmp = a[left];
			a[left] = a[right];
			a[right] = tmp;
			// ［左］を１つ右へ進めます
			left++;
			// ［右］を１つ左へ進めます
			right--;
		}
		// もし左側に分割するデータがあったら
		if (startID < left-1) {
			// 左側のデータを同じように分割します
			quickSort(a, startID,left-1);
		}
		// もし右側に分割するデータがあったら
		if (right+1 < endID) {
			// 右側のデータを同じように分割します
			quickSort(a, right+1,endID);
		}
	}
	
public static void main(String[] args) {
		// 《 クイックソートを行います 》
		// ソート前の配列データです
		int a[] = {10,3,1,9,7,6,8,2,4,5};
		
		// 先頭から末尾までソートします
		quickSort(a, 0,a.length-1);

		// ソート後の配列を表示します
		for (int i: a) {
			System.out.println(i);
		}
	}

}
