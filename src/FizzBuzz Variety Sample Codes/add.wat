;; 引数$aと$bを加算する関数の定義
(module ;; --- (*1)
  (type (;0;) (func (param i32 i32) (result i32))) ;; --- (*2)
  (func (;0;) (type 0) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.add ;; --- (*3)
    return)
  (export "add" (func 0))) ;; --- (*4)
