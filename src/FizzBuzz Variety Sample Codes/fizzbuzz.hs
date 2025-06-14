module Main where

-- (*1) 1から100までの値にfizzBuzz関数を適用して表示
main :: IO()
main = printAll $ map fizzBuzz [1..100]
    where
    printAll [] = return ()
    printAll (x:xs) = putStrLn x >> printAll xs

-- (*2) FizzBuzzに応じた値を返す関数を定義
fizzBuzz :: Int -> String
fizzBuzz i | (i `mod` 3 == 0) && (i `mod` 5 == 0) = "FizzBuzz"
    | i `mod` 3 == 0 = "Fizz"
    | i `mod` 5 == 0 = "Buzz"
    | otherwise = show i

