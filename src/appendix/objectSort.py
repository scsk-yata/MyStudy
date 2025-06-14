# ソート前の配列データです
a = []
# 名前と点数をまとめたオブジェクトを追加していきます	
a.append({"name":"A", "score":10})
a.append({"name":"B", "score":30})
a.append({"name":"C", "score":100})
a.append({"name":"D", "score":80})
a.append({"name":"E", "score":70})

# 調べる範囲の開始位置を１つずつ後ろへ移動していくくり返し
for i in range(len(a)):
	# 後ろから前に向かって小さい値を浮かび上がらせるくり返し
	for j in range(len(a)-1, i, -1):
		# # 隣り合う２つのscore値のうち、後ろの方の値が大きかったら
		if a[j]["score"] > a[j-1]["score"] :
			# オブジェクトを交換して、前に移動します
			tmp = a[j]
			a[j] = a[j-1]
			a[j-1] = tmp

# 結果を表示します
print("ソート後=")
for i in range(len(a)):
	print(a[i]["name"]+":"+str(a[i]["score"]))
