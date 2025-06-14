Sub minMax()
    Dim a, max

    'データを配列に用意します
    a = Array(1, 3, 10, 2, 8)
    ' 最大値に最初の値を入れて初期化します
    max = a(0)
    ' 2つ目から最後まで、くり返します
    For i = 1 to UBound(a)
        ' もし最大値よりも値が大きければ
        if max < a(i) Then
            ' 最大値を値で上書きします
            max = a(i)
        End If
    Next i
    ' 結果を表示します
    Debug.Print "最大値=" & max
End Sub