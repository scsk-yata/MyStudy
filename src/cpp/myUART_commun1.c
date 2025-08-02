// UARTのシリアル通信プログラム
#include <stdio.h>      // 標準入出力（printfなど）を使用するためのヘッダ
#include <stdlib.h>     // 標準ライブラリ（exit(), malloc()など）
#include <string.h>     // 文字列処理関数（strlen(), memset()など）
#include <fcntl.h>      // ファイル制御（open(), O_RDWRなど）用
#include <errno.h>      // エラー番号や perror() を使うため
#include <termios.h>    // POSIX標準のシリアル通信設定用API（termios構造体など）
#include <unistd.h>     // UNIX標準関数群（read(), write(), close()など）

int main() {
    const char* device = "/dev/ttyUSB0";  // 通信に使うデバイスファイル名（例：USBシリアル変換器）
    int baudrate = B9600;                 // 通信速度（ここでは9600bpsを設定）

    // デバイスファイルをオープン。O_RDWR: 読み書き、O_NOCTTY: 制御端末にしない、O_NDELAY: 非ブロッキング
    int serial_fd = open(device, O_RDWR | O_NOCTTY | O_NDELAY);
    if (serial_fd == -1) {  // open()が失敗した場合（-1を返す）
        perror("Error opening serial port");  // エラー説明を標準エラー出力に表示
        return 1;  // 異常終了
    }

    // termios構造体を宣言し、現在のシリアルポートの属性を取得
    struct termios options;
    tcgetattr(serial_fd, &options);  // ファイルディスクリプタ serial_fd の設定を options に格納

    // 入力側（受信側）のボーレート（通信速度）を設定
    cfsetispeed(&options, baudrate);  // ここではB9600（9600bps）を設定

    // 出力側（送信側）のボーレート（通信速度）を設定
    cfsetospeed(&options, baudrate);  // 入出力は9600bpsで統一

    // 以下の処理で「8N1」設定：8ビットデータ、パリティなし、1ストップビット
    
    // パリティを無効化（偶数/奇数パリティなし）
    options.c_cflag &= ~PARENB;

    // ストップビットを1に設定（CSTOPB=1で2ビット設定となるため、ここでは無効化）
    options.c_cflag &= ~CSTOPB;

    // データビットサイズを設定する前に、サイズに関連するビットをクリア
    options.c_cflag &= ~CSIZE;

    // データビット数を8に設定（CS8: 8ビット）
    options.c_cflag |= CS8;

    // CLOCAL: モデム制御を無視してローカル接続用とする、CREAD: 受信有効化
    options.c_cflag |= (CLOCAL | CREAD);

    // 以下はRAWモード設定：特殊文字やエコー、シグナル等を無効化

    // カノニカルモード（行単位の入力）を無効化、さらにエコーも無効
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);

    // ソフトウェアフロー制御（XON/XOFF）を無効化
    options.c_iflag &= ~(IXON | IXOFF | IXANY);

    // 出力処理（改行変換などの特殊文字）を無効化
    options.c_oflag &= ~OPOST;

    // 上記で設定したオプションをすぐに反映（TCSANOW: 即時）
    tcsetattr(serial_fd, TCSANOW, &options);

    // 実際に送信する文字列
    const char* msg = "Hello, UART World!\n";

    // write関数でデバイスに送信（msgの長さ分だけ送信）
    int bytes_written = write(serial_fd, msg, strlen(msg));
    printf("Sent %d bytes: %s\n", bytes_written, msg);  // 送信したバイト数と内容を表示

    // 受信バッファの用意（256バイト分）
    char buffer[256];
    memset(buffer, 0, sizeof(buffer));  // バッファを0クリア（安全対策）

    // read関数で受信（最大255バイトまで読み込み、末尾はNULLで終端）
    int bytes_read = read(serial_fd, buffer, sizeof(buffer) - 1);
    if (bytes_read > 0) {  // 1バイト以上読み取った場合
        printf("Received %d bytes: %s\n", bytes_read, buffer);  // 受信内容を表示
    } else {
        printf("No data received.\n");  // データ読み取りができなかった場合のメッセージ
    }

    // 使用が終わったらシリアルポートを閉じる
    close(serial_fd);

    // 正常終了
    return 0;
}