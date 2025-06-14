// FizzBuzzを返す関数を定義 --- (*1) 
let fizzbuzz n =
    match (n % 3 = 0), (n % 5 = 0) with // ---(*2)
        | true, false  -> "Fizz"
        | false, true  -> "Buzz"
        | true, true   -> "FizzBuzz"
        | false, false -> sprintf "%d" n

// 1から100までの要素を繰り返し実行 --- (*3)
[1..100] 
    |> List.iter (fun n -> printfn "%s" (fizzbuzz n))
    |> ignore

