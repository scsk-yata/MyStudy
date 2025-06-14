#include <iostream>
class FizzBuzz { // --- (*1)
  private:
    int max;
  public:
    FizzBuzz(int num) { // コンストラクタを定義 --- (*2)
      this->max = num;
    }
    void run () { // 処理を実行するメソッドを定義 --- (*3)
      for (int i = 1; i <= max; i++) {
        this->check(i);
      }
    }
    void check(int i) { // 各数を確認するメソッドを定義
      if (i % 3 == 0 && i % 5 == 0) std::cout << "FizzBuzz";
      else if (i % 3 == 0) std::cout << "Fizz";
      else if (i % 5 == 0) std::cout << "Buzz";
      else std::cout << i;
      std::cout << "\n";
    }
};

int main() {
  // クラスからインスタンスを生成して実行 --- (*4)
  FizzBuzz *obj = new FizzBuzz(100);
  obj->run();
  return 0;
}

