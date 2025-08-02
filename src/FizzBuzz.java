public class FizzBuzz { // --- (*1)
  private int max;
  public FizzBuzz(int max) { // --- (*2)
    this.max = max;
  }
  public void run() { // --- (*3)
    for (int i = 1; i <= this.max; i++) {
      printNum(i);
    }
  }
  public void printNum(int i) { // --- (*4)
    if (i % 3 == 0 && i % 5 == 0) {
      System.out.println("FizzBuzz");
    } else if (i % 3 == 0) {
      System.out.println("Fizz");
    } else if (i % 5 == 0) {
      System.out.println("Buzz");
    } else {
      System.out.println(i);
    }
  }
  public static void main(String[] args) { // --- (*5)
    FizzBuzz obj = new FizzBuzz(100);
    obj.run();
  }
}


