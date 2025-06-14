// データを配列に用意します
var a = [1,3,10,2,8]

// 合計値を0に初期化します
var sum = 0
// データの個数だけくり返します
for i in 0..<a.count {
	// 各値を足します
	sum += a[i]
}
// 平均値を計算します
var average = Float(sum) / Float(a.count)
// 結果を表示します
print("平均=",average)
