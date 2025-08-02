// I2C通信を利用するためのWireライブラリを読み込み
#include <Wire.h>

// Adafruit製MPR121センサライブラリを読み込み（Library Managerで要インストール）
#include "Adafruit_MPR121.h"

// MPR121のインスタンスを作成（デフォルトI2Cアドレス: 0x5A）
Adafruit_MPR121 cap = Adafruit_MPR121();

// 最後にタッチされていた電極の状態を保持するための変数（ビットフラグ形式）
uint16_t lasttouched = 0;

// 現在タッチされている電極の状態を保持するための変数（ビットフラグ形式）
uint16_t currtouched = 0;

// 各電極（0〜11）のタッチ状態をブール値で保持する配列（1:タッチ中, 0:非タッチ）
boolean touchStates[12];

void setup() {
  // シリアル通信を9600bpsで初期化（PC側のモニターと通信可能に）
  Serial.begin(9600);

  // LeonardoやMicroなどのUSB通信初期化待ち（不要なら削除可）
  while (!Serial) {
    delay(10);  // 通信準備が整うまで待機
  }

  // 開始メッセージを出力
  Serial.println("MPR121 Capacitive Touch sensor test");

  // MPR121の初期化（I2Cアドレス: 0x5A）
  int check = cap.begin(0x5A);

  // cap.begin() は成功すると true を返す → 失敗時はエラーメッセージを出して停止
  if (!check) {
    Serial.println("MPR121 not found, please check wiring");
    while (1);  // 永久ループで停止（デバッグ用）
  }

  // 初期化成功時のメッセージ
  Serial.println("MPR121 found!");
}

void loop() {
  // 現在タッチされている電極の状態を取得（12ビット分、各ビットが1ならタッチ中）
  currtouched = cap.touched();

  // デバッグ用にビット列として現在の状態を表示
  Serial.println(cap.touched(), BIN);

  // 前回と異なるタッチ状態が検出された場合のみ処理を行う
  if (currtouched != lasttouched) {
    // 12個の電極それぞれに対して状態をビットでチェック
    for (int i = 0; i < 12; i++) {
      // i番目のビットが1ならタッチされている → touchStates[i] を 1 に
      if (currtouched & (1 << i)) {
        touchStates[i] = 1;
      } else {
        touchStates[i] = 0;  // タッチされていなければ 0 に
      }
    }

    // 12個の電極状態を1行のブーリアン文字列として出力（例: 100000000010）
    for (int i = 0; i < 12; i++) {
      Serial.print(touchStates[i]);
    }
    Serial.println();  // 行末で改行する場合はlnをつける
  }

  // 状態を更新（次回ループ時に差分検出できるように）
  lasttouched = currtouched;
}