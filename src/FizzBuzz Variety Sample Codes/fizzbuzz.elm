import String
import Html
import List

main = 
    List.range 1 100 |> List.map fizzBuzz |> String.join " " |> Html.text

fizzBuzz : Int -> String
fizzBuzz i = 
    case (remainderBy 3 i, remainderBy 5 i) of
        (0, 0) -> "FizzBuzz"
        (0, _) -> "Fizz"
        (_, 0) -> "Buzz"
        _ -> String.fromInt i
