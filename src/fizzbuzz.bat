@echo OFF

setlocal enabledelayedexpansion

for /l %%i in (1,1,100) do (
  set /a fizzbuzz=%%i %% 15
  set /a fizz=%%i %% 3
  set /a buzz=%%i %% 5
  REM echo !fizzbuzz! !fizz! !buzz!
  if !fizzbuzz! equ 0 (
    echo FizzBuzz
  ) else (
    if !fizz! equ 0 (
      echo Fizz
    ) else (
      if !buzz! equ 0 (
        echo Buzz
      ) else (
        echo %%i
      )
    )
  )
)

endlocal
