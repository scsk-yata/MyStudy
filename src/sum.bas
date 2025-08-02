Sub sum()
    Dim a, sum

    'データを配列に用意します
    a = Array(1, 3, 10, 2, 8)
    ' 合計値を0に初期化します
    sum = 0
    ' データの個数だけくり返します
    For i = 0 To UBound(a)
        ' 各値を足します
        sum = sum + a(i)
    Next i
    ' 結果を表示します
    Debug.Print "合計=" & sum
End Sub