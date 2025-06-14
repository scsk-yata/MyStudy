// FizzBuzzの値を返す関数を定義 --- (*1)
// : numberなどが型の注釈。ここでは引数iと関数fizzbuzzの返り値に注釈。
const fizzbuzz = (num: number): string => {
  const isFizz = (i: number) => i % 3 === 0 // 引数iはnumberと注釈。
  const isBuzz = (i: number) => i % 5 === 0 // 引数iはnumberと注釈。
  if (isFizz(num) && isBuzz(num)) return 'FizzBuzz'
  if (isFizz(num)) return 'Fizz'
  if (isBuzz(num)) return 'Buzz'
  return num.toString()
}

// 1から100まで繰り返しfizzbuzz関数を呼び出す --- (*2)
for (let i = 1; i <= 100; i++) {
  console.log(fizzbuzz(i))
}
