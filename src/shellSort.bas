Sub shellSort()
    Dim a, length, ins, i, j, step, tmp
    ' ソート前の配列データです
    a = Array(10, 3, 1, 9, 7, 6, 8, 2, 4, 5)

    ' 要素の個数を調べます
    length = UBound(a) + 1
    ' 「グループ分けの間隔」を半分にしていくくり返し
    st = length / 2
    Do While st > 0
        ' ［　間隔を開けて挿入ソート　］
        ' 配列から順番に１つずつ「挿入する値」を取り出すことをくり返します
        For i = st To length - 1
            ' 「挿入する値」を、変数に入れて待避します
            tmp = a(i)
            ' 取り出した位置から前に向かって比較をくり返します
            j = i
            For j = i To st Step -st
                If a(j - st) > tmp Then
                    ' もし「挿入する値」が小さければ、その値をstep幅だけ後ろへずらします
                    a(j) = a(j - st)
                Else
                    ' もし「挿入する値」が小さくなければ、そこでずらす処理を止めます
                    Exit For
                End If
            Next j
            ' ずらす処理が終わったところに「挿入する値」を入れます
            a(j) = tmp
        Next i
        st = st / 2
    Loop

    ' ソート後の配列を表示します
    Debug.Print "ソート後 ="
    For i = 0 To UBound(a)
        Debug.Print a(i)
    Next i
End Sub
