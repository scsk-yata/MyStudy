package main
import ("fmt")

// メイン関数
func main() {
    // 構造体を生成して初期化 --- (*1)
    fb := FizzBuzz{1, 100}
    fb.Run() // 実行
}

// FizzBuzz構造体を定義 --- (*2)
type FizzBuzz struct {
    Cur int
    Max int
}
// 構造体FizzBuzzで処理実行のメソッド --- (*3)
func (p *FizzBuzz) Run() {
    // 指定回数だけ繰り返す --- (*4)
    for ; p.Cur <= p.Max; p.Cur++ {
        fmt.Println(p.GetValue())
    }
}
// 構造体FizzBuzzで条件を判定するメソッド --- (*5)
func (p* FizzBuzz) IsFizz() bool {
    return p.Cur % 3 == 0
}
func (p* FizzBuzz) IsBuzz() bool {
    return p.Cur % 5 == 0
}
// 構造体FizzBuzzでFizzBuzzの値を取得するメソッド --- (*6)
func (p *FizzBuzz) GetValue() string {
    switch {
    case p.IsFizz() && p.IsBuzz():
        return "FizzBuzz"
    case p.IsFizz():
        return "Fizz"
    case p.IsBuzz():
        return "Buzz"
    default:
        return fmt.Sprint(p.Cur)
    }
}
