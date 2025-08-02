// I2C通信のサンプルプログラム
#include <stdio.h>       // 標準入出力（printf など）を使用するためのヘッダ
#include <stdlib.h>      // 標準ライブラリ関数（exit など）を使用するためのヘッダ
#include <fcntl.h>       // open() や O_RDWR などのファイル制御用の定義を含む
#include <unistd.h>      // read(), write(), close() などUNIX標準関数用ヘッダ
#include <sys/ioctl.h>   // ioctl() システムコール使用のためのヘッダ
#include <linux/i2c-dev.h> // I2C通信に必要な定義（I2C_SLAVE など）

int main(void) {
    const char *i2c_device = "/dev/i2c-1";  // I2Cバスデバイスファイルのパス（Raspberry Piなどではi2c-1）
    int i2c_fd;                             // I2Cデバイスを操作するためのファイルディスクリプタ
    int addr = 0x50;                        // 通信相手のI2Cスレーブアドレス（0x50）

    // デバイスファイルをオープン（読み書き両用）
    if ((i2c_fd = open(i2c_device, O_RDWR)) < 0) {
        perror("I2Cデバイスのオープンに失敗しました。");
        exit(1);  // エラー終了
    }

    // 通信相手のI2Cアドレスを設定（この操作がないとどのスレーブと通信するか判別できない）
    if (ioctl(i2c_fd, I2C_SLAVE, addr) < 0) {
        perror("I2Cスレーブアドレスの設定に失敗しました");
        close(i2c_fd); // 使用中のデバイスファイルを閉じる
        exit(1);
    }

    // 読み出したいレジスタのアドレス（例：EEPROM内のデータ位置）を送信
    unsigned char reg_addr = 0x00;  // 例えばEEPROMの先頭位置（0x00）を読む場合
    if (write(i2c_fd, &reg_addr, 1) != 1) {
        perror("レジスタアドレスの送信に失敗しました");
        close(i2c_fd);
        exit(1);
    }

    // 読み取り用のバッファ（1バイト分読み込む）
    unsigned char buf;
    if (read(i2c_fd, &buf, 1) != 1) {
        perror("データの読み取りに失敗しました");
        close(i2c_fd);
        exit(1);
    }

    // 読み取ったデータを表示
    printf("読み取ったデータ: 0x%02X\n", buf);

    // ファイルディスクリプタを閉じる（必ず実行）
    close(i2c_fd);

    return 0;
}