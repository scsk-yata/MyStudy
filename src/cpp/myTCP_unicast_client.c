/* TCP通信のクライアント側のプログラム */
#define _GNU_SOURCE // POSIXやISO C標準の関数＋glibcが提供する追加の関数や機能を使用可能
#include <stdio.h>      // 標準入出力関数（printf, perror, fopen, fclose など）
#include <stdlib.h>     // メモリ管理や終了関数（malloc, free, exit など）
#include <string.h>     // 文字列操作関数（memset, memcpy, strlen など）
#include <unistd.h>     // UNIX標準のシステムコール（close, read, write など）
#include <arpa/inet.h>  // ネットワーク関連（inet_ntop, htons, htonl など）
#include <netdb.h>      // DNS名前解決関連の関数（getaddrinfo, freeaddrinfo など）
#include <sys/socket.h> // ソケット通信用のAPI（socket, connect, send, recv など）

/* マクロ定数の定義 */
#define SERVER "127.0.0.1"  // ローカルサーバーに接続（リモートなら "www.scsk.jp" など）
#define PORT "8080"         // TCPサーバーのポート番号
#define BUFFER_SIZE 4096    // 受信データのバッファサイズ
#define REQUEST "Hello, Server!\n"  // サーバーに送信するリクエストメッセージ　バッファリングを防ぐため改行が必要。
#define FILE_NAME "TCPRequest.html"

int main() {
    int sock;  // ソケットディスクリプタ
    struct addrinfo sockinfo, *res, *p; // アドレス情報の構造体
    char buffer[BUFFER_SIZE];  // 受信データのバッファ

    /*アドレス情報の設定*/
    memset(&sockinfo, 0, sizeof(sockinfo)); // メモリをゼロクリア
    sockinfo.ai_family = AF_INET;        // IPv4 を使用
    sockinfo.ai_socktype = SOCK_STREAM;  // TCP ストリーム通信

    /*ホスト名 → IPアドレス変換*/
    if (getaddrinfo(SERVER, PORT, &sockinfo, &res) != 0) {
        perror("getaddrinfo failed"); // DNS解決失敗
        return 1;
    }

    /*ソケット作成とサーバーへの接続*/
    for (p = res; p != NULL; p = p->ai_next) {
        sock = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
        if (sock < 0) continue; // ソケット作成失敗なら次のアドレスへ
        if (connect(sock, p->ai_addr, p->ai_addrlen) == 0) break; // 接続成功
        close(sock); // 失敗したらソケットを閉じる
    }
    if (p == NULL) {  // どのアドレスにも接続できなかった場合
        fprintf(stderr, "Connection failed\n");
        return 1;
    }
    freeaddrinfo(res); // メモリを解放

    /* 実際にデータ送信 */
    ssize_t sent_bytes = send(sock, REQUEST, strlen(REQUEST), 0);
    if (sent_bytes < 0) {
        perror("send failed");
        close(sock);
        return 1;
    }

    /* サーバーからのレスポンス受信 */
    FILE *file = fopen(FILE_NAME, "w");
    if (!file) {
        perror("File open failed");
        close(sock);
        return 1;
    }

    ssize_t bytes_received; // UNIXシステムコール、返り値に長さかエラー値(-1)をを返す場合(実際のエラーはerrnoに格納)
    while ((bytes_received = recv(sock, buffer, BUFFER_SIZE - 1, 0)) > 0) {
        buffer[bytes_received] = '\0'; // 文字列終端のNULL文字
        printf("Received from server: %s", buffer);  // 画面に出力
        fprintf(file, "%s", buffer);  // ファイルに保存
    }

    /* データ受信後の後処理 */
    fclose(file);
    close(sock);
    printf("\nResponse saved to response.html\n"); // 完了メッセージ
    return 0;
}