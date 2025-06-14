# FizzzBuzzの値を返す関数を定義 --- (*1)
Function FizzBuzz($n) {
  # FizzとBuzzの条件を満たすか確認 --- (*2)
  $isFizz = $n % 3 -eq 0
  $isBuzz = $n % 5 -eq 0
  # 条件をif文で確認 --- (*3)
  if ($isFizz -and $isBuzz) { return "FizzBuzz" }
  if ($isFizz) { return "Fizz" }
  if ($isBuzz) { return "Buzz" }
  return $n
}
# 1から100まで繰り返しFizzBuzz関数を実行する ---(*4)
@(1..100) | % { FizzBuzz $_ | Write-Host }


