PROGRAM fizzbuzz
        IMPLICIT NONE ! 暗黙の型宣言を禁止 --- (*1)
        INTEGER :: i  ! 変数iの宣言 --- (*2)
        ! 1から100まで繰り返す --- (*3)
        DO i = 1, 100
                ! 順次判定していく --- (*4)
                IF (MOD(i, 3) == 0 .AND. MOD(i, 5) == 0) THEN
                        PRINT *, "FizzBuzz"
                ELSE IF (MOD(i, 3) == 0) THEN
                        PRINT *, "Fizz"
                ELSE IF (MOD(i, 5) == 0) THEN
                        PRINT *, "Buzz"
                ELSE
                        PRINT *, i
                END IF
        END DO
END PROGRAM fizzbuzz

