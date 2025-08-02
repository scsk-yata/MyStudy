// RFID読み取り Arduinoコード（MFRC522ライブラリ使用）
// 使用環境: Raspberry Pi Pico W + MFRC522 + SPI通信

#include <SPI.h>           // SPI通信を使用するためのライブラリをインクルード
#include <MFRC522.h>       // RFIDリーダーMFRC522用ライブラリをインクルード

#define RST_PIN 9           // MFRC522のリセットピンをGPIO9に定義
#define SS_PIN 17           // SPIスレーブセレクトピンをGPIO17に定義

MFRC522 mfrc522(SS_PIN, RST_PIN); // RFIDリーダーのインスタンスを生成

// setup関数はArduino起動時に一度だけ実行される初期化処理
void setup() {
  Serial.begin(115200);        // シリアル通信を115200bpsで初期化
  while (!Serial) {            // シリアル接続が確立するまで待機（USB経由での通信安定化）
    delay(10);
  }
  simple_mfrc522_init();       // RFIDモジュールの初期化処理
}

// loop関数はArduinoが動作している間、無限に繰り返される処理
void loop() {
  Serial.println("Place a card to read...");   // カードをかざすようユーザーに表示
  simple_mfrc522_get_card();                   // カードの検出とUID取得
  String result = simple_mfrc522_read();       // セクター0からカードのデータを読み取る
  Serial.print("Read:");
  Serial.println(result);                      // 読み取った内容をシリアルに出力
}

// RFIDモジュールの初期化処理
void simple_mfrc522_init() {
  SPI.begin();               // SPIバスの初期化
  mfrc522.PCD_Init();        // MFRC522の初期化（PCD: Proximity Coupling Device）
}

// RFIDカードの検出とUIDの表示
void simple_mfrc522_get_card() {
  while (!mfrc522.PICC_IsNewCardPresent());    // 新しいカードが存在するまでループ
  while (!mfrc522.PICC_ReadCardSerial());      // カードのUIDが読めるまでループ

  Serial.print(F("Card UID:"));
  for (byte i = 0; i < mfrc522.uid.size; i++) { // UIDバイト列を順番に表示
    Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
    Serial.print(mfrc522.uid.uidByte[i], HEX);
  }

  MFRC522::PICC_Type piccType = mfrc522.PICC_GetType(mfrc522.uid.sak); // カードの種類を取得
  Serial.print(F(" PICC type: "));
  Serial.println(mfrc522.PICC_GetTypeName(piccType)); // 種類名を表示
}

// section指定なしでカードからデータを読み取る（デフォルト: section 0）
String simple_mfrc522_read() {
  return simple_mfrc522_read(0);               // セクション0を指定して読み取り
}

// 指定セクションのカードからデータを読み取る関数 override
String simple_mfrc522_read(byte section) {
  byte block = section * 3 + 1;                // MIFARE Classic 1Kの論理ブロック番号を算出

  MFRC522::MIFARE_Key key;                     // 認証用のキー構造体を作成
  for (byte i = 0; i < 6; i++) key.keyByte[i] = 0xFF; // 工場出荷時のデフォルトキー（0xFF）を設定

  byte len = 18;                               // 読み取りバッファのサイズ（最大18バイト）
  byte buffer[18];                             // データを格納するバッファ
  MFRC522::StatusCode status;                  // 処理ステータス格納用の変数

  // 指定ブロックへの認証処理
  status = mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, block, &key, &(mfrc522.uid));
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("Authentication failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return "";
  }

  // ブロックデータの読み取り
  status = mfrc522.MIFARE_Read(block, buffer, &len);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("Reading failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return ""; // MFRC522::StatusCode型
  }

  delay(1000);                                // 読み取り後の安定化のための待機
  mfrc522.PICC_HaltA();                        // カードとの通信を終了（HALTコマンド）
  mfrc522.PCD_StopCrypto1();                   // 認証セッションを終了

  String result;
  for (uint8_t i = 0; i < 16; i++) {           // 読み取った16バイトを文字列に変換
    result += String((char)buffer[i]);
  }
  return result;                               // 結果の文字列を返す
}
