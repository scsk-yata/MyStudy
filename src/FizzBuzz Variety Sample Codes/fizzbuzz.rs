// プログラムはmain関数から始まる --- (*1)
fn main() {
    for i in 1 .. 100+1 {
        let result = fizzbuzz(i);
        println!("{0}", result)
    }
}
// FizzBuzzを返す関数を定義 --- (*2)
fn fizzbuzz(i:i32) -> String {
    // 無名関数を定義 --- (*3)
    let is_fizz = |i| { i % 3 == 0 };
    let is_buzz = |i| { i % 5 == 0 };
    // 順次判定していく --- (*4)
    if is_fizz(i) && is_buzz(i) {
        return "FizzBuzz".to_string();
    } else if is_fizz(i) {
        return "Fizz".to_string();
    } else if is_buzz(i) {
        return "Buzz".to_string();
    } else {
        return i.to_string();
    }
}
