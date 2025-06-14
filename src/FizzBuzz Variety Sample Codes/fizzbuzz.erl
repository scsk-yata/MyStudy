-module(fizzbuzz).
-export([exec/0]).

% 再帰的にFizzBuzzの値を返す関数を定義 --- (*1)
fizzbuzz(0) -> ok; % 引数が0の時何もしない --- (*2)
fizzbuzz(N) -> 
  fizzbuzz(N-1), % 再帰的にfizzbuzz関数を実行 --- (*3)
  % FizzBuzzの値を判定して出力 --- (*4)
  X = if
	  N rem 15 == 0 -> "FizzBuzz";
	  N rem  3 == 0 -> "Fizz";
	  N rem  5 == 0 -> "Buzz";
	  true          -> integer_to_list(N)
	end,
  io:format("~s~n", [X]).

% fizzubuzz関数を引数100で呼び出す --- (*5)
exec() ->
  fizzbuzz(100).

