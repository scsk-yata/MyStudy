#include <SPI.h>              // SPI通信を使用するためのライブラリをインクルード
#include <MFRC522.h>          // RFIDリーダーMFRC522用ライブラリ

#define RST_PIN         9     // MFRC522のリセットピン
#define SS_PIN          17    // SPIのスレーブセレクトピン（SDA）

// RFIDリーダーオブジェクトを作成（使用するSDA, RSTピンを指定）
MFRC522 mfrc522(SS_PIN, RST_PIN);

void setup() {
  Serial.begin(115200);        // シリアル通信を115200ボーで初期化
  while (!Serial) {
    delay(10);                 // シリアル通信の安定を待つ（特にUSB経由時）
  }
  simple_mfrc522_init();       // RFIDモジュールを初期化
  Serial.println(F("Type string you want to write to section 0, ending with #"));
}

void loop() {
  byte buffer[34];             // 書き込み用バッファ（最大32文字＋終端用）
  byte len;

  // シリアルから「#」が来るまでの文字列を読み取り
  len = Serial.readBytesUntil('#', (char *)buffer, 30);
  if (len == 0) {
    return;                   // 入力がなければ処理を抜ける
  }
  for (byte i = len; i < 30; i++) buffer[i] = ' '; // 足りない部分はスペースで埋める

  Serial.println("Place a card to write...");
  simple_mfrc522_get_card();   // カードを検出し、UID等を表示
  simple_mfrc522_write(buffer); // カードにデータを書き込む
}

// RFIDリーダーの初期化処理
void simple_mfrc522_init() {
  SPI.begin();                 // SPI通信の初期化
  mfrc522.PCD_Init();          // RFIDモジュールの初期化
}

// RFIDカードを検出し、UIDおよびタイプをシリアル出力
void simple_mfrc522_get_card() {
  while (!mfrc522.PICC_IsNewCardPresent()); // 新しいカードがあるまで待機
  while (!mfrc522.PICC_ReadCardSerial());   // カード情報が読めるまで待機

  Serial.print(F("Card UID:"));
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
    Serial.print(mfrc522.uid.uidByte[i], HEX); // UIDを16進で表示
  }
  Serial.print(F(" PICC type: "));
  MFRC522::PICC_Type piccType = mfrc522.PICC_GetType(mfrc522.uid.sak);
  Serial.println(mfrc522.PICC_GetTypeName(piccType)); // カードのタイプ名を表示
}

// 文字列をセクション0に書き込む（便宜上）
void simple_mfrc522_write(String text) {
  simple_mfrc522_write(0, text);
}

// バッファ形式でセクション0に書き込む（内部関数）
void simple_mfrc522_write(byte* buffer) {
  simple_mfrc522_write(0, buffer);
}

// 文字列からバッファに変換して指定セクションに書き込む
void simple_mfrc522_write(byte section, String text) {
  byte buffer[34];
  text.getBytes(buffer, 34);
  simple_mfrc522_write(section, buffer);
}

// 実際の書き込み処理（2ブロック：16+16バイト）
void simple_mfrc522_write(byte section, byte* buffer) {
  byte block = section * 3 + 1; // 各セクションは3ブロックごとに管理（0:1-2, 1:4-5）
  MFRC522::StatusCode status;
  MFRC522::MIFARE_Key key;
  for (byte i = 0; i < 6; i++) key.keyByte[i] = 0xFF; // 初期パスワード

  // 最初のブロックへの認証
  status = mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, block, &key, &(mfrc522.uid));
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("PCD_Authenticate() failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  }
  Serial.println(F("PCD_Authenticate() success: "));

  // 最初のブロックに書き込み（16バイト）
  status = mfrc522.MIFARE_Write(block, buffer, 16);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE_Write() failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  }
  Serial.println(F("MIFARE_Write() success: "));

  block += 1; // 次のブロックへ
  // 再認証
  status = mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, block, &key, &(mfrc522.uid));
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("PCD_Authenticate() failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  }
  // 残りのデータを書き込み
  status = mfrc522.MIFARE_Write(block, &buffer[16], 16);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE_Write() failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  }
  Serial.println(F("MIFARE_Write() success: "));

  // カード通信を終了
  Serial.println(" ");
  mfrc522.PICC_HaltA();
  mfrc522.PCD_StopCrypto1();
}

// セクション0から文字列を読み出す
String simple_mfrc522_read() {
  return simple_mfrc522_read(0);
}

// 指定セクションのブロックから読み出しを行う
String simple_mfrc522_read(byte section) {
  byte block = section * 3 + 1;
  MFRC522::MIFARE_Key key;
  for (byte i = 0; i < 6; i++) key.keyByte[i] = 0xFF;

  byte len;
  MFRC522::StatusCode status;
  byte buffer[18];
  len = 18;

  // ブロックへの認証
  status = mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, block, &key, &(mfrc522.uid));
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("Authentication failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return "";
  }

  // 読み出し処理
  status = mfrc522.MIFARE_Read(block, buffer, &len);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("Reading failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return "";
  }

  delay(1000); // 次の読み取りまでの待機時間

  mfrc522.PICC_HaltA();
  mfrc522.PCD_StopCrypto1();

  String result;
  for (uint8_t i = 0; i < 16; i++) {
    result += String((char)buffer[i]); // 文字列として変換
  }
  return result;
}
