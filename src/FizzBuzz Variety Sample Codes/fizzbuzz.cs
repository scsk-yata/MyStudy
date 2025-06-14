class FizzBuzz {
  public static void Main() { // --- (*1)
    // 100回繰り返す
    for (int i = 1; i <= 100; i++) { // --- (*2)
      // FizzBuzzの条件を順に判定していく --- (*3)
      if (i % 3 == 0 & i % 5 == 0) cout("FizzBuzz");
      else if (i % 3 == 0) cout("Fizz");
      else if (i % 5 == 0) cout("Buzz");
      else cout(i.ToString());
    }
  }
  // コンソールに文字を出力するメソッドを定義 --- (*4)
  public static void cout(string s) {
    System.Console.WriteLine(s);
  }
}

