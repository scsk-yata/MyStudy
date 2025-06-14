Sub bubblesort()
    Dim a, i, j, tmp
    ' ソート前の配列データです
    a = Array(10, 3, 1, 4, 2)

    ' 調べる範囲の開始位置を１つずつ後ろへ移動していくくり返し
    For i = 1 To UBound(a)
        ' 後ろから前に向かって小さい値を浮かび上がらせるくり返し
        For j = UBound(a) To i Step -1
            ' 隣り合う２つの、後ろの方の値が小さかったら
            If a(j) < a(j - 1) Then
                ' 交換して、前に移動します
                tmp = a(j)
                a(j) = a(j - 1)
                a(j - 1) = tmp
            End If
        Next j
    Next i

    ' ソート後の配列を表示します
    Debug.Print "ソート後 ="
    For i = 0 To UBound(a)
        Debug.Print a(i)
    Next i
End Sub