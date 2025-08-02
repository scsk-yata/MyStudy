#include <iostream>
class FizzBuzz { // classの中にデータメンバやコンストラクタが定義されている
  private:
    int max; // データメンバ
  public:
    FizzBuzz(int max) { // コンストラクタの定義
      this->max = max; // classのmaxと仮引数のmaxを区別。
    }
    void run () { // 処理を実行するメソッドを定義
      for (int i = 1; i <= max; i++) {
        this->check(i);
      }
    }
    void check(int i) { // 各数を確認するメソッドを定義 上記のrunで使用されている
      if (i % 3 == 0 && i % 5 == 0) std::cout << "FizzBuzz";
      else if (i % 3 == 0) std::cout << "Fizz";
      else if (i % 5 == 0) std::cout << "Buzz";
      else std::cout << i;
      std::cout << "\n"; // 標準入出力ストリームの最後
    }
};

int main() {
  // クラスからインスタンスを生成して実行 maxには100と設定する
  FizzBuzz *obj = new FizzBuzz(100); // newによって初期化してコンストラクト
  obj->run();
  return 0;
}
