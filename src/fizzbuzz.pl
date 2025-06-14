# 1から100まで繰り返す --- (*1)
for my $i (1..100) {
  print fizzbuzz($i)."\n";
}

# fizzbuzzに応じた値を返す --- (*2)
sub fizzbuzz {
  my $i = $_[0];
  my $is_fizz = ($i % 3 == 0);
  my $is_buzz = ($i % 5 == 0);
  return 'FizzBuzz' if ($is_fizz && $is_buzz);
  return 'Fizz' if ($is_fizz);
  return 'Buzz' if ($is_buzz);
  $i; # --- (*3)
}

