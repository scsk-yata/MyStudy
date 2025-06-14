; FizzBuzzを返す関数を定義 --- (*1)
(defun fizzbuzz(i)
  ; 順次判定していく --- (*2)
  (cond
    ((= 0 (mod i 15)) "FizzBuzz")
    ((= 0 (mod i  3)) "Fizz")
    ((= 0 (mod i  5)) "Buzz")
    (t (write-to-string i))))

; 100回繰り返す --- (*3)
(loop for i from 1 to 100 do
  (format t "~A~%" (fizzbuzz i)))

