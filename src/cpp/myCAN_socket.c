/* SocketCANを使用してCANフレームを送信するプログラム */
#define _GNU_SOURCE
/*
 * ECU間通信（エンジン制御、ブレーキ制御など）を模した基本的なフレーム送信
 * Linux上のSocketCAN対応システム（Raspberry Pi + CANドングル）
 * インターフェース: can0（事前にip link set can0 up type can bitrate 500000などで有効化が必要）
 */
#include <stdio.h>      // 標準入出力を扱うためのヘッダーファイル
#include <stdlib.h>     // 標準ライブラリのヘッダーファイル
#include <unistd.h>     // UNIX標準のシンボル定義、POSIX OS API(closeなど)
#include <string.h>     // 文字列操作を行うためのヘッダーファイル
#include <errno.h>      // エラー番号を扱うためのヘッダーファイル
// SocketCANはLinuxカーネルに統合されたCAN protocolのサポート、ソケットAPIを通じてCANデバイスと通信
#include <sys/socket.h> // ソケットAPIを使用するためのヘッダーファイル
#include <sys/ioctl.h>  // 入出力制御を行うためのヘッダーファイル
#include <net/if.h>     // ネットワークインターフェースを扱うためのヘッダーファイル
#include <linux/can.h>  // CANプロトコルの定義を含むヘッダーファイル
#include <linux/can/raw.h> // RAWモードでCANソケットを使用するためのヘッダーファイル

#define CAN_INTERFACE "vcan0" // 使用するCANインターフェースの名前

int main() {
    int sock; // ソケットディスクリプター
    struct ifreq ifr; // ネットワークインターフェースの設定を行うための構造体
    struct sockaddr_can addr; // CAN通信用のソケットアドレス構造体
    struct can_frame frame; // CANフレーム情報を格納する構造体

    // ソケットの作成　プロトコルファミリーをCANバスに設定
    sock = socket(PF_CAN, SOCK_RAW, CAN_RAW); // 生のCANデータフレームを送る(BCM,ISOTPも存在)、フィルタリングなしのRAW CANフレーム
    if (sock < 0) {
        perror("socket creation failed");
        return 1;
    }

    // CAN通信に使用するネットワークインターフェース名を設定
    strncpy(ifr.ifr_name, CAN_INTERFACE, sizeof(ifr.ifr_name) - 1);
    ifr.ifr_name[sizeof(ifr.ifr_name) - 1] = '\0'; // 文字列として扱うために終端文字を加える。

    /* インターフェースのインデックスを取得、CAN通信はインターフェース名にバインドする必要あり
    SIOCGIFINDEX は、指定したNWIF(sock)のIF Indexを取得するためのリクエストコード。
    ifr（ifreq型の構造体） に、指定したインターフェース情報を格納。 */
    if (ioctl(sock, SIOCGIFINDEX, &ifr) < 0) { // ioctl()はデバイスドライバとやり取りするための関数。
        perror("Setting interface index failed");
        close(sock);
        return 1;
    }

    // ソケットアドレス構造体の設定、sockaddr_can型の構造体addr
    addr.can_family = AF_CAN; // アドレスファミリー指定
    addr.can_ifindex = ifr.ifr_ifindex; // 対象のCAN I/Fにバインドする

    // ソケットにアドレスをバインド
    if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("socket binding failed");
        close(sock);
        return 1;
    }

    // 送信するCANフレームの設定
    frame.can_id = 0x123; // CAN ID（メッセージ種別）を１６進数で設定、エンジンECU用
    frame.can_dlc = 2;    // データ長を2バイトに設定（最大８バイト）
    frame.data[0] = 0xAB; // データ1バイト目を0xABに設定
    frame.data[1] = 0xCD; // データ2バイト目を0xCDに設定

    // ソケットを使用してCANフレーム送信
    if (write(sock, &frame, sizeof(frame)) != sizeof(struct can_frame)) {
        perror("Send CAN frame failed");
        close(sock);
        return 1;
    }

    printf("CANフレームを送信しました。 CAN ID = 0x%03X, DLC = %d, Data = [0x%02X 0x%02X]\n",
                                    frame.can_id, frame.can_dlc, frame.data[0], frame.data[1]);

    // ソケットのクローズ、メモリの開放
    close(sock);
    return 0;
}