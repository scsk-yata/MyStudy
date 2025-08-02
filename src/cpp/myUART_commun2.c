/* Universal Asynchronous Receiver/Transmitter */
#define _GNU_SOURCE
#include <stdio.h>      // 標準入出力を使用するためのヘッダーファイル
#include <stdlib.h>     // 標準ライブラリを使用するためのヘッダーファイル
#include <fcntl.h>      // ファイル制御に関する定義を含むヘッダーファイル
#include <termios.h>    // (UNIX標準)端末I/O操作のための定義を含むヘッダーファイル
#include <unistd.h>     // POSIX APIを使用するためのヘッダーファイル
#include <string.h>     // 文字列操作のためのヘッダーファイル

int main() {
    struct termios options;  // UARTの設定を記憶するための構造体
    char buffer[256];  // 受信データを格納するバッファ

    /* // デバイスファイルのファイルディスクリプタ
    O_RDWR : UARTデバイスを操作できるファイルを読み書きモードで開く
    O_NOCTTY : 端末デバイス（tty）を開いた際に制御端末として設定されるのを防ぐ
    非ブロッキングモード：open時にDCD（キャリア検出）を無視。read/write時も待たずに即座に制御を返す */
    int uart_fd = open("/dev/ttyS0", O_RDWR | O_NOCTTY | O_NDELAY);
    if (uart_fd == -1) {  // システムコールやライブラリ関数の呼び出しエラーメッセージを表示
        perror("UART open error");
        return 1;  // プログラムを終了
    }

    // 現在のUART設定を取得してoptionsに格納
    tcgetattr(uart_fd, &options);

    // 入出力のボーレート（通信速度）を、9600bpsに設定(Picoのシリアル通信時のデフォルト)
    cfsetispeed(&options, B9600); // 115200bps
    cfsetospeed(&options, B9600); // 115200bps

    // コントロールモードフラグにより端末のハードウェア制御を設定
    options.c_cflag &= ~PARENB;  // パリティビットを無効に設定
    options.c_cflag &= ~CSTOPB;  // ストップビットを1ビットに設定(2bitもある)
    options.c_cflag &= ~CSIZE;   // データビットのマスクをクリア
    options.c_cflag |= CS8;      // データビットを8ビットに設定(7bitにも設定可能)

    // フロー制御の設定
    options.c_cflag &= ~CRTSCTS;  // ハードウェアフロー制御(rts/cts)を無効に設定
    options.c_iflag &= ~(IXON | IXOFF | IXANY);  // ソフトウェアフロー制御を無効

    // ローカルモードと受信モードを有効に設定
    options.c_cflag |= (CLOCAL | CREAD);
    // ​モデムの制御線などの接続状態に関係なく、プログラムがデバイスを操作できるように設定
    // CREAD → 受信機能を有効にし、データの受信を可能

    // 端末のローカルモード制御用フィールドのフラグ　キャノニカルモード（行単位の入力）を無効に設定
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    // ICANON：​キャノニカルモード（標準入力モード）を有効
    // 非キャノニカルモード（生入力モード）フラグを立てて、入力が即時にプログラムに渡される
    // ECHO：入力された文字を端末に表示（エコーバック）する
    // ECHOE：バックスペースキーで入力文字を消す処理を有効化（エコー付き編集）
    // ISIG：​特定の入力文字（INTR, QUIT, SUSPなど）を受信した際に、対応するシグナルを生成
    
    // 端末の出力モードを制御するフィールド。
    options.c_oflag &= ~OPOST;// 改行コード（\n → \r\n など）の自動変換を含む出力処理を無効にする

    // タイムアウトと最小文字数の設定
    options.c_cc[VMIN] = 0;   // 最小読み取り文字数を0に設定。受信データがなくてもreadは即座に返る
    // （VTIMEと組み合わせた場合、最大 VTIME*100ms 待機）
    options.c_cc[VTIME] = 10; // 読み取りタイムアウトを1秒（10 * 100ms）に設定
    
    // ファイルディスクリプタで指定した端末の属性に関するUART設定
    if (tcsetattr(uart_fd, TCSANOW, &options) != 0) {
    // TCSANOW：​変更を即時に適用するように指定 
    // &options：​新しい設定を含むtermios構造体へのポインタ
        perror("UART attribute get error");
        close(uart_fd);
        return 1;
    }
    

    // 実際にUARTからのデータ受信
    int bytes_received = read(uart_fd, buffer, sizeof(buffer));  // データを読み取る
    if (bytes_received < 0) {
        perror("UART data read error");  // エラーが発生した場合、エラーメッセージを表示
    } else if (bytes_received == 0) {
        printf("No data received.\n");   // データが受信されなかった場合のメッセージ
    } else if (bytes_received < sizeof(buffer) - 1) {
        buffer[bytes_received] = '\0';  // 安全な位置に終端文字を付加
    } else { // 文字列として扱うために受信データの末尾にNULL文字を追加
        buffer[sizeof(buffer) - 1] = '\0';  // 末尾の文字をNULL文字に強制変更
        printf("Received data: %s\n", buffer);  // 受信データを表示
    }

    // UARTへのデータ送信
    const char *send_data = "Hello, UART!\n";  // 送信するデータ
    int bytes_transmitted = write(uart_fd, send_data, strlen(send_data));  // データを送信
    if (bytes_transmitted < 0) {
        perror("UART data write error");  // データ送信に失敗した場合、エラーメッセージを表示
    } else {
        printf("Sent data: %s", send_data);  // 送信したデータを表示
    }

    // UARTデバイスファイルをクローズ
    close(uart_fd);

    return 0;  // プログラムの正常終了
}