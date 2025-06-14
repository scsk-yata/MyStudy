class FizzBuzz { // --- (*1)
  int max;
  FizzBuzz(int max) { // --- (*2)
    this.max = max;
  }
  void Run() { // --- (*3)
    for (int i = 1; i <= max; i++) {
      System.Console.WriteLine(this.Check(i));
    }
  }
  string Check(int i) { // --- (*4)
    if (i % 3 == 0 & i % 5 == 0) return "FizzBuzz";
    if (i % 3 == 0) return "Fizz";
    if (i % 5 == 0) return "Buzz";
    return i.ToString();

  }
  public static void Main() { // --- (*5)
    FizzBuzz obj = new FizzBuzz(100);
    obj.Run();
  }
}

