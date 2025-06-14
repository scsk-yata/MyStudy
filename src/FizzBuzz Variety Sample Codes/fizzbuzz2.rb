# FizzBuzzクラスを定義 --- (*1)
class FizzBuzz
  # 初期化メソッド --- (*2)
  def initialize(max)
    @max = max
    # FizzとBuzzの判定条件を定義 --- (*3)
    @is_fizz = lambda { |n| n % 3 == 0 }
    @is_buzz = lambda { |n| n % 5 == 0 }
  end
  # 繰り返しFizzBuzzの値を出力 --- (*4)
  def run
    1.upto(@max){ |n| puts check(n) }
  end
  # FizzBuzzの値を判定 --- (*5)
  def check(n)
    if @is_fizz.call(n) and @is_buzz.call(n)
      "FizzBuzz"
    elsif @is_fizz.call(n)
      "Fizz"
    elsif @is_buzz.call(n)
      "Buzz"
    else
      n.to_s
    end
  end
end

# クラスをインスタンス化して実行 --- (*6)
fb = FizzBuzz.new(100)
fb.run


