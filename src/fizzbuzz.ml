(* FizzBuzzを返す関数を定義 --- [1] *)
let fizzbuzz i = match i mod 3, i mod 5 with
      0, 0 -> "FizzBuzz"
    | 0, _ -> "Fizz"
    | _, 0 -> "Buzz"
    | _    -> string_of_int i

(* 100回、fizzbuzzを呼び出す --- [2] *)
let () =
  for i = 1 to 100 do print_endline @@ fizzbuzz i done

