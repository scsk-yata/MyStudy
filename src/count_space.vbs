Option Explicit

Function CountSpace(str)
    Dim i, count
    For i = 1 To Len(str)
        If Mid(str, i, 1) = " " Then
            count = count + 1
        End If
    Next
    CountSpace = count
End Function

MsgBox CountSpace("This is a pen.")
