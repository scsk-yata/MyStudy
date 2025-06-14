// FizzBuzzクラスを定義 --- (*1)
class FizzBuzz {
  constructor(max) { // コンストラクタ --- (*2)
    this.max = max
    this.cur = 1
  }
  get isEnd () { // 繰り返しの終了判定関数 --- (*3)
    return this.max < this.cur
  }
  next () { // カーソルを次に移動する関数 --- (*4)
    this.cur++
  }
  run () { // 繰り返しFizzBuzzの結果を表示する --- (*5)
    while (!this.isEnd) {
      console.log(this.value)
      this.next()
    }
  }
  // FizzBuzzを判定するメソッド --- (*6)
  get isFizz () { return this.cur % 3 == 0 }
  get isBuzz () { return this.cur % 5 == 0 }
  // FizzBuzzの結果を求めるメソッド --- (*7)
  get value () {
    if (this.isFizz && this.isBuzz) return "FizzBuzz"
    if (this.isFizz) return "Fizz"
    if (this.isBuzz) return "Buzz"
    return this.cur
  }
}
// オブジェクトを生成して実行 --- (*8)
const fb = new FizzBuzz(100)
fb.run()

