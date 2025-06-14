; FizzBuzzの値を返す関数を定義 --- (*1)
(define (fizzbuzz i)
  (cond
    ((= 0 (modulo i 15)) "FizzBuzz")
    ((= 0 (modulo i  3)) "Fizz")
    ((= 0 (modulo i  5)) "Buzz")
    (else i)))

; 再帰を使って100回繰り返す --- (*2)
(define (fizzbuzz_rec i)
  (if (<= i 100)
    (begin
      (print (fizzbuzz i))
      (fizzbuzz_rec (+ i 1)))))

(fizzbuzz_rec 1)
