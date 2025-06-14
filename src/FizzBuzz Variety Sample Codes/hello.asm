bits 64 ; 64bitモードを明示
global _start

; メインプログラムを記述する .text セクション --- (*1)
section .text
_start:
    mov rax, 1      ; Linuxのsys_writeを指定 --- (*2)
    mov rdi, 1      ; stdoutを指定
    mov rsi, str    ; strのアドレスを格納
    mov rdx, length ; lengthを格納
    syscall         ; システムコールを呼び出す

    mov rax, 60 ; Linuxのsys_exitを指定 --- (*3)
    mov rdi, 0  ; 引数として0を指定
    syscall     ; システムコールを呼び出す

; プログラム中で利用するデータを保持する .data セクション --- (*4)
section .data
    str: db "Hello, World!",10 ; 文字列データのstrを定義
    length equ $ - str         ; 文字列の長さ

