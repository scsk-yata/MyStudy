package main // パッケージの指定 --- (*1)
import ("fmt") // 基本ライブラリの取込み --- (*2)

func main() { // メイン関数 --- (*3)
    for i := 1; i <= 100; i++ {
        result := FizzBuzz(i)
        fmt.Println(result)
    }
}

func FizzBuzz(i int) (string) { // --- (*4)
    switch { // --- (*5)
    case i % 3 == 0 && i % 5 == 0:
        return "FizzBuzz"
    case i % 3 == 0:
        return "Fizz"
    case i % 5 == 0:
        return "Buzz"
    default:
        return fmt.Sprint(i)
    }
}

