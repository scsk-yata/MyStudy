#!/bin/bash
# FizzBuzzを返す関数を定義 --- (*1)
fizzbuzz () {
  # if文で順次条件を判定 --- (*2)
  if [[ 0 -eq "($1 % 3) + ($1 % 5)" ]]
  then
    echo "FizzBuzz"
  elif [[ 0 -eq "($1 % 3)" ]]
  then
    echo "Fizz"
  elif [[ 0 -eq "($1 % 5)" ]]
  then
    echo "Buzz"
  else
    echo "$1"
  fi
}

# 関数を繰り返し実行する --- (*3)
for i in {1..100}; 
do 
  fizzbuzz $i
done

