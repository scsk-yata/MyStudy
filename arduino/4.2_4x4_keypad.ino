// Adafruit社のキーパッド制御ライブラリをインクルード（行列スキャンなどを自動化）
#include "Adafruit_Keypad.h"

// キーパッドの行と列の数を定義（4行4列のマトリックス）
const byte ROWS = 4;
const byte COLS = 4;

// それぞれのキーに割り当てられたキャラクタ（見た目通りのラベル）
// 例：2行目3列目（row=1, col=2）はキー '6'
char keys[ROWS][COLS] = {
  { '1', '2', '3', 'A' },
  { '4', '5', '6', 'B' },
  { '7', '8', '9', 'C' },
  { '*', '0', '#', 'D' }
};

// 各行（row）ピンとArduinoの接続ピン（G2～G5を想定）
byte rowPins[ROWS] = { 2, 3, 4, 5 };

// 各列（col）ピンとArduinoの接続ピン（G6～G9を想定）
byte colPins[COLS] = { 6, 7, 8, 9 };

// Adafruit_Keypadライブラリのインスタンス生成（キー配列とピン配置を渡す）
Adafruit_Keypad myKeypad = Adafruit_Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

void setup() {
  // シリアルモニタとの通信初期化（9600bps）
  Serial.begin(9600);

  // キーパッドの初期化（ピンの入出力設定やスキャン状態の初期化）
  myKeypad.begin();
}

void loop() {
  // 現在のキーの状態を更新（スキャン実行）
  myKeypad.tick();

  // 一番新しいキーイベント（押された／離された）を表示する
  while (myKeypad.available()) {
    // 1件のキーイベントを読み取る
    keypadEvent e = myKeypad.read();

    // 押された／離されたキーの文字を表示（例: '5'）
    Serial.print((char)e.bit.KEY);

    // 押下イベントか離脱イベントかを表示
    if (e.bit.EVENT == KEY_JUST_PRESSED) {
      Serial.println(" pressed");
    } else if (e.bit.EVENT == KEY_JUST_RELEASED) {
      Serial.println(" released");
    }
  }

  // 次のスキャンまで10ms待つ（デバウンス等のため）
  delay(10);
}
