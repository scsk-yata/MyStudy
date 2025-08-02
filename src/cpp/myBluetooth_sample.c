#include <stdio.h>                  // printf(), perror() などの標準入出力関数
#include <stdlib.h>                 // malloc(), free(), exit() などの汎用関数
#include <unistd.h>                 // close() などのUNIX系システムコール
#include <bluetooth/bluetooth.h>    // Bluetoothアドレス構造体や変換関数
#include <bluetooth/hci.h>          // HCI (Host Controller Interface) の関数・構造体
#include <bluetooth/hci_lib.h>      // HCI関連の高レベルAPI

// 定数定義
#define INQUIRY_LEN      8           // 探索時間 (1.28sec × 8 = 約10.24秒)
#define MAX_RESPONSES    255         // 最大取得デバイス数

int main() {
    inquiry_info *ii = NULL;        // デバイス情報を格納する構造体ポインタ
    int dev_id, sock;               // デバイスID, ソケットディスクリプタ
    int num_rsp;                    // 応答のあったデバイス数
    char addr[19] = { 0 };          // Bluetoothアドレス（文字列型）保存用
    char name[248] = { 0 };         // デバイス名（最大248文字）

    // Bluetoothアダプタの取得
    // 使用可能なBluetoothアダプタ（hciデバイス）のIDを取得
    dev_id = hci_get_route(NULL);
    if (dev_id < 0) {               // -1 の場合、取得失敗
        perror("Bluetoothアダプタが見つかりません");
        exit(EXIT_FAILURE);
    }

    // Bluetoothソケットのオープン
    // dev_id で指定されたBluetoothアダプタに対応するソケットを開く
    sock = hci_open_dev(dev_id);
    if (sock < 0) {                 // ソケットが開けない場合
        perror("ソケットオープン失敗");
        exit(EXIT_FAILURE);
    }

    // メモリの確保
    // 最大 MAX_RESPONSES 個分の inquiry_info 構造体領域を動的確保
    ii = (inquiry_info*)malloc(MAX_RESPONSES * sizeof(inquiry_info));
    if (ii == NULL) {               // malloc失敗時
        perror("メモリ確保失敗");
        close(sock);
        exit(EXIT_FAILURE);
    }

    // Bluetoothデバイス探索開始
    // Bluetooth Inquiry（探索）開始
    // IREQ_CACHE_FLUSH: キャッシュを無視して最新情報取得
    num_rsp = hci_inquiry(dev_id, INQUIRY_LEN, MAX_RESPONSES, NULL, &ii, IREQ_CACHE_FLUSH);
    if (num_rsp < 0) {              // 探索失敗時
        perror("デバイス探索失敗");
        free(ii);
        close(sock);
        exit(EXIT_FAILURE);
    }

    printf("発見したデバイス数: %d\n", num_rsp);

    // 発見したデバイス一覧表示
    for (int i = 0; i < num_rsp; i++) {
        // Bluetoothアドレス構造体 → 文字列変換（aa:bb:cc:dd:ee:ff形式）
        ba2str(&(ii[i].bdaddr), addr);

        // nameバッファを初期化
        memset(name, 0, sizeof(name));

        // リモートデバイスの名前取得（失敗時は "[名前取得失敗]" とする）
        if (hci_read_remote_name(sock, &(ii[i].bdaddr), sizeof(name), name, 0) < 0) {
            strcpy(name, "[名前取得失敗]");
        }

        // デバイス情報出力
        printf("デバイス %s  名称: %s\n", addr, name);
    }

    // リソースの解放
    free(ii);                       // mallocしたメモリ解放
    close(sock);                     // ソケットクローズ

    return 0;                        // 正常終了
}
