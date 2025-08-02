Sub binSearch()
    Dim a, searchValue, findID
    Dim left, right, middle

    ' 検索する配列データです
    a = Array(1, 2, 4, 5, 10)
    ' この値を探します
    searchValue = 4
    ' 見つかったときの番号。初期値は、エラーの値（-1）にしておきます
    findID = -1
    
    ' 調べる左端の番号です
    left = 0
    ' 調べる右端の番号です
    right = UBound(a)
    ' 調べる左端と右端の間にデータがある間は、くり返します
    Do While left <= right:
        ' 左右の真ん中の番号を調べる位置にします
        middle = Int((left + right) / 2)
        ' 調べる位置の値と、探す値を比較して
        If a(middle) = searchValue Then
            ' 同じなら、その番号を保存してくり返しを終了します
            findID = middle
            Exit Do
        ElseIf a(middle) < searchValue Then
            ' 探す値より小さければ、そこより左に探すデータはないので、左端を移動します
            left = middle + 1
        Else
            ' 探す値より大きければ、そこより右に探すデータはないので、右端を移動します
            right = middle - 1
        End If
    Loop
    ' 検索結果を表示します
    Debug.Print "見つかった番号=" & findID
End Sub
