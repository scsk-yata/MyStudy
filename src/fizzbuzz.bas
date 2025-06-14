10 REM 100回繰り返す --- (*1)
20 FOR I=1 TO 100
30 M=I
31 REM 条件を次々と判定 --- (*2)
40 IF(I % 3) = 0 THEN M="Fizz"
50 IF(I % 5) = 0 THEN M="Buzz"
60 IF(I % 15) = 0 THEN M="FizzBuzz"
70 PRINT M, "\n"
80 NEXT I

