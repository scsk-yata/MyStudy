Sub SelectionSort()
    Dim a, length, min, i, j, k, tmp
    ' ソート前の配列データです
    a = Array(10, 3, 1, 4, 2)

    ' 要素の個数を調べます
    length = UBound(a) + 1
    ' 「最小値を入れる位置」を、先頭から順番に選択していくくり返し
    For i = 0 To length - 2
        ' ［　最小値を探すアルゴリズム　］
        ' まず、先頭の値を暫定の最小値として初期化します
        min = a(i)
        ' 先頭の位置も保存しておきます
        k = i
        ' 隣の位置から最後まで、最小値との比較をくり返します
        For j = i + 1 To length - 1
            ' もし最小値よりも小さい値が見つかったら
            If min > a(j) Then
                ' 最小値を上書きして
                min = a(j)
                ' その位置を保存しておきます
                k = j
            End If
        Next j
        ' ［　交換するアルゴリズム　］
        ' 「先頭の値」と「最小値の値」を交換します
        tmp = a(i)
        a(i) = a(k)
        a(k) = tmp
    Next i

    ' ソート後の配列を表示します
    Debug.Print "ソート後 ="
    For i = 0 To UBound(a)
        Debug.Print a(i)
    Next i
End Sub
