% FizzBuzzの値を返す条件を定義 --- (*1)
fizzbuzz(N) :- 
  0 is N mod 3, 0 is N mod 5, write('FizzBuzz'), nl;
  0 is N mod 3, 0 <  N mod 5, write('Fizz'), nl;
  0 is N mod 5, 0 <  N mod 3, write('Buzz'), nl;
  0 <  N mod 3, 0 <  N mod 5, write(N), nl.

% 1から100を処理する --- (*2)
?- forall(between(1, 100, I), fizzbuzz(I)).

