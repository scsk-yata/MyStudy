Sub insertSort()
    Dim a, length, ins, i, j, tmp
    ' ソート前の配列データです
    a = Array(10, 3, 1, 4, 2)

    ' 要素の個数を調べます
    length = UBound(a) + 1
    ' 「整列していない部分」から、順番に１つずつ取り出していきます
    For i=1 to length-1
        ' 「挿入する値」を、変数に取り出します
        tmp = a(i)
        ' 挿入する位置の変数を用意します
        ins = 0
        ' 「「整列済みの部分」のどこに挿入すればいいかを、後ろから前に向かって順番に見ていきます
        For j=i-1 to 0 Step -1
            ' もし「挿入する値」が小さければ
            If a(j) > tmp Then
                ' そこに挿入できるように、調べた値を１つ後ろへずらします
                a(j+1) = a(j)
            Else
                ' もし「挿入する値」が小さくなければ、そこでずらす処理を止めます
                ' 挿入する位置を変数insに保存します
                ins = j+1
                Exit For
            EndIf
        Next j
        ' ずらす処理が終わった位置に「挿入する値」を入れます
        a(ins) = tmp
    Next i

    ' ソート後の配列を表示します
    Debug.Print "ソート後 ="
    For i = 0 To UBound(a)
        Debug.Print a(i)
    Next i
End Sub
