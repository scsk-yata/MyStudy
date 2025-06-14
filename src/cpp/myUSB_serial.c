/* USB通信 CDC:Communication Device Class */
#include <stdio.h>       // 標準入出力関数（printfなど）
#include <stdlib.h>      // 標準ライブラリ（exitなど）
#include <fcntl.h>       // ファイル制御（open, fcntl）
#include <unistd.h>      // UNIXシステムコール（read, write, close）
#include <termios.h>     // シリアル通信設定用の構造体・定数
#include <string.h>      // 文字列操作用関数（memsetなど）

int main() {
    int fd;  // ファイルディスクリプタ（USBシリアルポート）

    // USBシリアルデバイスのファイルパス（OSが自動割り当て、環境に応じて適宜変更）
    const char *device = "/dev/ttyUSB0";

    // デバイスファイルを読み書き可能として開く（ノンブロッキングは無し）
    fd = open(device, O_RDWR | O_NOCTTY); // 端末制御を奪わないようにするフラグ
    if (fd < 0) {
        perror("デバイスファイルのオープン失敗");
        return 1;
    }

    // termios構造体を用いてシリアル通信の設定を取得
    struct termios options; //シリアル通信の詳細設定を保持する 
    tcgetattr(fd, &options);  // 現在の設定を取得してoptionsに格納する

    // 通信速度（ボーレート）設定：9600bps（入力・出力ともに）
    cfsetispeed(&options, B9600);
    cfsetospeed(&options, B9600);

    // パリティなし（誤り検出ビットの無効化）
    options.c_cflag &= ~PARENB;

    // ストップビットを1に設定（2ビット指定はCSTOPBをONにする）
    options.c_cflag &= ~CSTOPB;

    // データビット長を8ビットに設定
    options.c_cflag &= ~CSIZE;  // 初期化：ビット長設定用ビットをクリア
    options.c_cflag |= CS8;     // 8ビットに設定

    // CLOCAL: モデム制御を使わずローカルに使用する
    // CREAD: データ受信を有効化する
    options.c_cflag |= (CLOCAL | CREAD);

    // キャノニカルモード（行入力モード）をオフ
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);

    // 出力をそのまま送信する（OPOSTがあるとLF→CR+LF変換などが入る）
    options.c_oflag &= ~OPOST;

    // 入力フロー制御を無効化（IXON:送信停止, IXOFF:受信停止）
    options.c_iflag &= ~(IXON | IXOFF | IXANY);

    // 改行コードの変換をオフ（ICRNL: CR→NL, INLCR: NL→CR）
    options.c_iflag &= ~(ICRNL | INLCR);

    // 最低読み取りバイト数（0にすると非ブロッキング読み取りが可能）
    options.c_cc[VMIN] = 0;

    // タイムアウト値（100ms単位×10で１秒）
    options.c_cc[VTIME] = 10;

    // 上記設定をデバイスに即座に反映（TCSANOW: 即時）
    tcsetattr(fd, TCSANOW, &options);

    // USBシリアルへ送る文字列（任意に変更可）
    const char *msg = "USBからのテスト送信\n";

    int len = write(fd, msg, strlen(msg));  // deviceへの書き込み実行
    if (len < 0) {
        perror("書き込みエラー");
    } else {
        printf("送信完了: %dバイト\n", len);
    }

    // 受信バッファ配列に格納する
    char buffer[256];
    memset(buffer, 0, sizeof(buffer));  // バッファ初期化

    // 受信データ読み出し
    int n = read(fd, buffer, sizeof(buffer) - 1);  // 最大255バイト受信
    if (n < 0) {
        perror("受信エラー");
    } else if (n == 0) {
        printf("データなし（タイムアウト）\n");
    } else {
        buffer[n] = '\0';  // 文字列終端(NULL)を追加
        printf("受信データ: %s\n", buffer);
    }

    // ファイルディスクリプタを閉じて、デバイス制御終了
    close(fd);

    return 0;
}
