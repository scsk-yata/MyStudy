#import <Foundation/Foundation.h>
// クラスの宣言 --- (*1)
@interface FizzBuzz : NSObject {
    int max; // インスタンス変数の宣言
}
// インスタンスメソッドを宣言 --- (*2)
- (void)run;
- (char*)getValue:(int)n;
- (void)setMax:(int)v;
@end
// FizzBuzzクラスの実装 --- (*3)
@implementation FizzBuzz
- (void)setMax:(int)v { max = v; } // 最大値を設定
// FizzBuzzの値を繰り返し表示 --- (*4)
- (void)run
{
    for (int i = 1; i <= max; i++) {
        printf("%s\n", [self getValue:i]);
    }
}
// FizzBuzzの値の条件を判定し順に取得する --- (*5)
- (char*)getValue:(int)n {
    static char buf[256];
    if (n % 3 == 0 && n % 5 == 0) return "FizzBuzz";
    if (n % 3 == 0) return "Fizz";
    if (n % 5 == 0) return "Buzz";
    sprintf(buf, "%d", n);
    return buf;
}
@end
// メイン関数--- (*6)
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        id fb = [FizzBuzz new];
        [fb setMax:100];
        [fb run];
    }
    return 0;
}

