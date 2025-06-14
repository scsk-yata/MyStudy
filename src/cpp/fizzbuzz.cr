class FizzBuzz
  @is_fizz : Proc(Int32, Bool) # 型定義
  @is_buzz : Proc(Int32, Bool)

  def initialize(max : Int32 ) # 型定義
    @max = max 
    @is_fizz = -> (n : Int32 ) { n % 3 == 0 }
    @is_buzz = -> (n : Int32 ) { n % 5 == 0 }
  end

  def run
    1.upto(@max){ |n| puts check(n) }
  end

  def check(n)
    if @is_fizz.call(n) && @is_buzz.call(n) # 比較には&&
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

fb = FizzBuzz.new(100)
fb.run
