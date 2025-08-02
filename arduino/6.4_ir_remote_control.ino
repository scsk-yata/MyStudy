// IRremoteライブラリを読み込む。IR信号のデコードや送受信に使用する。
#include <IRremote.h>

// IR受信機を接続するGPIOピン番号を定義（ここではGP17に接続）
const int receiverPin = 17;

void setup() {
  // シリアル通信を9600ボーで開始（PCのシリアルモニターと通信するため）
  Serial.begin(9600);

  // IR受信機を初期化（第1引数にピン番号、第2引数にLEDフィードバック機能の有無）
  IrReceiver.begin(receiverPin, ENABLE_LED_FEEDBACK);
}

void loop() {
  // IR信号を受信したかどうかをチェック
  if (IrReceiver.decode()) {
    // 受信したIRコマンドから対応するキー文字列を取得するカスタム関数実行
    String key = decodeKeyValue(IrReceiver.decodedIRData.command);

    // もし対応するキーが見つかれば（"ERROR"でなければ）シリアルモニターに出力
    if (key != "ERROR") {
      Serial.println(key);  // 受信したボタン名を表示
      delay(100);           // 誤入力防止のために100msの待機
    }

    // 次の信号を受信できるようにIR受信機の内部状態をリセット
    IrReceiver.resume();
  }
}

// IRリモコンの信号値（16進数）を、対応するボタンの名称に変換する関数
String decodeKeyValue(long result) {
  switch (result) {
    case 0x45: return "POWER";        // 電源ボタン
    case 0x47: return "MUTE";         // ミュート
    case 0x46: return "MODE";         // モード変更
    case 0x44: return "PLAY/PAUSE";   // 再生・一時停止
    case 0x40: return "BACKWARD";     // 巻き戻し
    case 0x43: return "FORWARD";      // 早送り
    case 0x07: return "EQ";           // イコライザー
    case 0x15: return "-";            // ボリュームダウン
    case 0x09: return "+";            // ボリュームアップ
    case 0x19: return "CYCLE";        // リピートなどの切替
    case 0x0D: return "U/SD";         // USB/SD切替

    // 数字キー（0〜9）
    case 0x16: return "0";
    case 0x0C: return "1";
    case 0x18: return "2";
    case 0x5E: return "3";
    case 0x08: return "4";
    case 0x1C: return "5";
    case 0x5A: return "6";
    case 0x42: return "7";
    case 0x52: return "8";
    case 0x4A: return "9";

    // 想定外の値 → エラー扱い
    case 0x00: return "ERROR";
    default:   return "ERROR";
  }
}