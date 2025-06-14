#include <stdio.h>
#include <math.h>

void _funcI(void)
{
    printf("エラー : 正の値を入力してください．\n");
}

float _funcII_1(void)
{
    float v;
    printf("真数の値を入力してください:");
    scanf("%f", &v); // scanfで入力された値を浮動小数点数型の変数vに格納
    return v;
}

void _funcII_2(float b)
{
    printf("入力された値は%fです．\n", b);
}

float _funcIII(float b)
{
    float c;
    c = 10 * log10(b);
    return c;
}
////////////////////////////////////////////////////////////////////////////
int main(void)
{
    float a, a_dB;
    a = _funcII_1();
    if (a == 0.0)
        _funcI();
    else
    {
        _funcII_2(a);
        a_dB = _funcIII(a); // 戻り値のある関数は式の中で変数のように扱える。
        printf("それは%f[dB]です．\n", a_dB);
    }
    return 0;
}