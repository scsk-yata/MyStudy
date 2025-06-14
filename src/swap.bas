Sub swap()
    Dim a, b, t

    ' 交換前のデータです
    a = 10
    b = 20
    ' tに、aの値を入れて待避させます
    t = a
    ' aに、bの値を入れます
    a = b
    ' bに、待避させたtの値を入れます
    b = t
    ' 結果を表示します
    Debug.Print "a=" & a & ",b=" & b
End Sub