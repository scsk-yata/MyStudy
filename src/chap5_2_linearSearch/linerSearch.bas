Sub linerSearch()
    Dim a, searchValue, findID
    ' 検索する配列データです
    a = Array(10, 3, 1, 4, 2)
    ' この値を探します
    searchValue = 4
    ' 見つかったときの番号。初期値は、エラーの値（-1）にしておきます
    findID = -1
    
    ' 配列のすべての値を調べていきます
    For i = 0 To UBound(a)
        ' 配列の値と、探す値が同じなら
        If a(i) = searchValue Then
            ' その番号を保存して、くり返しを終了します
            findID = i
            Exit For
        End If
    Next i
    ' 検索結果を表示します
    Debug.Print "見つかった番号=" & findID
End Sub
