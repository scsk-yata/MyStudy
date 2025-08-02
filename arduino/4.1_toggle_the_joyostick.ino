// ジョイスティックの各出力ピンを接続するGPIO番号の定義
const int xPin = A1;     // 水平軸（VRX）：アナログ入力ピンA1に接続
const int yPin = A0;     // 垂直軸（VRY）：アナログ入力ピンA0に接続
const int swPin = 22;    // スイッチ（SW）：デジタル入力ピン22に接続（Z軸）

void setup()
{
  // SWピンを入力モードに設定
  pinMode(swPin, INPUT);

  // 3.3Vの電源に10KΩのプルアップ抵抗が接続されていることを想定。
  // ボタンが押されていない時にSWピンはHIGHになる。
  digitalWrite(swPin, HIGH);  // 安定したHIGHレベルを得るために初期値をHIGHに（外部プルアップあり）

  // シリアルモニタの通信速度を9600bpsに設定して通信開始
  Serial.begin(9600);
}

void loop()
{
  // 水平方向のアナログ値（0～1023）を読み取り
  Serial.print("X: "); 
  Serial.print(analogRead(xPin), DEC);  // analogRead()でA1ピンの電圧（VRX）を取得し10bit整数で出力

  // 垂直方向のアナログ値（0～1023）を読み取り
  Serial.print(" | Y: ");
  Serial.print(analogRead(yPin), DEC);  // A0ピンの電圧（VRY）を取得し10bit整数で出力

  // スイッチ（Z軸）の状態を読み取り（1=押していない、0=押されている）
  Serial.print(" | Z: ");
  Serial.println(digitalRead(swPin));   // SWピンの状態をデジタル入力として取得（HIGH or LOW）

  // 500ミリ秒（0.5秒）待機してループを繰り返す
  delay(500);
}