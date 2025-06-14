Imports System
Module Module1
    ' メイン関数を定義 --- (*1)
    Sub Main()
        Dim i As Integer
        For i = 1 To 100 ' ---- (*2)
            Console.WriteLine(fizzbuzz(i))
        Next
    End Sub
    ' FizzBuzzの値を返す関数 --- (*3)
    Public Function fizzbuzz(i As Integer) As String
        If (i Mod 3 = 0) And (i Mod 5 = 0) Then
            Return "FizzBuzz"
        ElseIf i Mod 3 = 0 Then
            Return "Fizz"
        ElseIf i Mod 5 = 0 Then
            Return "Buzz"
        Else
            Return i
        End If
    End Function
End Module

