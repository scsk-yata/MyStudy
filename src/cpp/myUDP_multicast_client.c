// UDPマルチキャスト通信のクライアント側プログラム
#define _GNU_SOURCE
#include <stdio.h>      // 標準入出力のヘッダーファイル
#include <stdlib.h>     // 標準ライブラリのヘッダーファイル
#include <string.h>     // 文字列操作のヘッダーファイル
#include <arpa/inet.h>  // インターネット操作のヘッダーファイル
#include <sys/socket.h> // ソケット操作のヘッダーファイル
#include <unistd.h>     // UNIX標準のヘッダーファイル

#define MULTICAST_GROUP "239.255.255.255" // マルチキャストグループのIPアドレス
#define MULTICAST_PORT 12345          // マルチキャストグループのポート番号
#define BUFFER_SIZE 256               // 受信バッファのサイズ

int main() {
    int sockfd, cnt = 3; // ソケットファイルディスクリプタ
    struct sockaddr_in local_addr; // ローカルアドレス情報を格納する構造体
    struct ip_mreq mreq; // マルチキャストリクエスト用の情報を含む構造体
    char buffer[BUFFER_SIZE]; // 受信バッファ
    int nbytes; // 戻り値（受信バイト数）を受け取る変数
    socklen_t addrlen; // 戻り値（アドレス長）を受け取る変数

    // ソケットの作成（IPv4、データグラムDGRAMソケット、UDPプロトコル）
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("UDP socket creation failed"); // エラーメッセージの表示
        exit(EXIT_FAILURE); // プログラムの異常終了
    }

    // ローカルアドレス構造体の初期化
    memset(&local_addr, 0, sizeof(local_addr)); // 構造体のゼロクリア
    local_addr.sin_family = AF_INET; // アドレスファミリの設定（IPv4）
    local_addr.sin_addr.s_addr = htonl(INADDR_ANY); // 任意のローカルアドレスの受け入れ設定
    local_addr.sin_port = htons(MULTICAST_PORT); // ポート番号の設定（ネットワークバイトオーダーに変換）

    // ソケットにローカルアドレスをバインド sockaddr_in型のlocal_addr変数
    if (bind(sockfd, (struct sockaddr*)&local_addr, sizeof(local_addr)) < 0) {
        perror("function 'bind' failed"); // エラーメッセージの表示
        close(sockfd); // ソケットのクローズ
        exit(EXIT_FAILURE); // プログラムの異常終了
    }

    // マルチキャストグループへの参加設定
    mreq.imr_multiaddr.s_addr = inet_addr(MULTICAST_GROUP); // マルチキャストグループのIPアドレスを設定
    mreq.imr_interface.s_addr = htonl(INADDR_ANY); // 任意のローカルインターフェースを使用する設定
    // ソケットのオプション設定(IP protocol)に、マルチキャストリクエストに関する情報をセット
    if (setsockopt(sockfd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq)) < 0) {
        perror("adding multicast group failed"); // エラーメッセージの表示
        close(sockfd); // ソケットのクローズ
        exit(EXIT_FAILURE); // プログラムの異常終了
    }

    // 受信ループの開始
    while (cnt) {
        addrlen = sizeof(local_addr); // アドレス長の初期化

        // データの受信
        if ((nbytes = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0, (struct sockaddr*)&local_addr, &addrlen)) < 0) {
            perror("function 'recvfrom' failed"); // エラーメッセージの表示
            break; // ループの終了
        }

        buffer[nbytes] = '\0'; // 受信データの終端にNULL文字を追加
        printf("Received multicast messages: %s\n", buffer); // 受信メッセージの表示
        printf("last %d count\n",cnt--);

    }

    // マルチキャストグループからの離脱
    if (setsockopt(sockfd, IPPROTO_IP, IP_DROP_MEMBERSHIP, &mreq, sizeof(mreq)) < 0) {
        perror("dropping multicast group failed"); // エラーメッセージの表示
    }

    close(sockfd); // ソケットのクローズ
    return 0; // プログラムの正常終了
}