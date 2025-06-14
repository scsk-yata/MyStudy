let fizzbuzz i = 
    match (i % 3, i % 5) with
    | 0, 0 -> "FizzBuzz"
    | 0, _ -> "Fizz"
    | _, 0 -> "Buzz"
    | _, _ -> sprintf "%d" i
    
for i in [1..100] do
    fizzbuzz i |> printfn "%s"
