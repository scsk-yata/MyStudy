/* SSLライブラリを使用せずにhttps://www.scsk.jpにアクセスしてhtmlファイルを取得するプログラム */
#define _GNU_SOURCE      // vscode上で構造体addrinfoの定義を認識させるため
#include <stdio.h>       // 標準入出力関数（printf, fprintf, perror, fopen, fcloseなど）
#include <stdlib.h>      // メモリ管理関数（malloc, free)や終了関数(exit）
#include <string.h>      // 文字列操作関数（memset, memcpy, strlenなど）
#include <unistd.h>      // UNIX標準のシステムコール関数（close, read, writeなど）
#include <arpa/inet.h>   // NWアドレス変換の関数（inet_ntop, htons, htonl）
#include <netdb.h>       // DNS名前解決関連の関数（getaddrinfo, freeaddrinfo）
#include <sys/types.h> // vscode上で構造体addrinfoの定義を認識させるため
#include <sys/socket.h>  // ソケット通信のためのAPI（socket, connect, send, recv）

/*マクロ定数の定義*/
#define SERVER "www.scsk.jp"      // アクセス先のWebサーバーのドメイン名
#define PORT "80"                 // プロトコルがHTTPの時のポート番号
#define BUFFER_SIZE 4096          // 受信データのバッファサイズ
#define FILE_NAME "response.html" // 受け取ったhtmlドキュメントを保存するため

/* 送信するHTTPリクエスト（GETメソッド）　HTTPのヘッダーは改行コード \r\n で区切る必要がある。*/
#define REQUEST "GET / HTTP/1.1\r\n\
                Host: " SERVER "\r\n\
                Connection: close\r\n\r\n"

/* アドレス情報を格納する構造体の定義（vscodeでnetdb.hのaddrinfoが認識されないことがあるため。） */
#ifndef _NETDB_H
    struct addrinfo {
        int ai_flags;       // 特別な動作フラグ（AI_PASSIVE など）
        int ai_family;      // アドレスファミリー（AF_INETはIPv4, AF_INET6はIPv6に対応）
        int ai_socktype;    // ソケットの種類（SOCK_STREAMはTCP, SOCK_DGRAMはUDPに対応）
        int ai_protocol;    // プロトコル（通常は0）
        struct sockaddr *ai_addr; // IPアドレス情報のポインタ
        size_t ai_addrlen;  // `ai_addr` のサイズ
        char *ai_canonname; // ホスト名の「公式名」文字列へのポインタ
        struct addrinfo *ai_next; // 次の参照アドレス情報（リスト構造）
    };
#endif

int main() {
    int sock;  // ソケットディスクリプタ（ソケット通信の識別子として整数値を使用する）
    struct addrinfo sockinfo, *p, *res;  // アドレス情報の構造体
    char buffer[BUFFER_SIZE];  // 受信データを格納する文字列型のバッファ

    // アドレス情報の設定
    memset(&sockinfo, 0, sizeof(sockinfo)); // 安全に初期化するため構造体のメモリをゼロクリア
    sockinfo.ai_family = AF_INET;        // IPv4アドレスファミリー
    sockinfo.ai_socktype = SOCK_STREAM;  // TCPストリーム通信に設定（UDPならSOCK_DGRAM）

    /* ホスト名 → IPアドレス変換 を実行する関数
    getaddrinfo()を使えばIPv6 (AF_INET6) に対応
    gethostbyname() はIPv6に対応していないため、getaddrinfo() を推奨とのこと */
    if (getaddrinfo(SERVER, PORT, &sockinfo, &res) != 0) {
        perror("function 'getaddrinfo' failed");
        return 1; // DNS解決に失敗した場合、異常終了値を返す。
    }

    /* ソケット作成とサーバーへの接続をする関数の引数と戻り値
    int socket(int domain, int type, int protocol);
    int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
     */
    for (p = res; p != NULL; p = p->ai_next) { // 複数のアドレスを試す
        sock = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
        if (sock < 0) {
            continue;  // ソケット作成失敗した場合は次のアドレスへ
        } else if (connect(sock, p->ai_addr, p->ai_addrlen) == 0){
            break; // 接続成功ならfor文を抜ける
        } else {
            close(sock); // サーバ接続に失敗したらソケットを閉じる
        }
    }
    if (p == NULL) {  // どのアドレスにも接続できなかった場合
        fprintf(stderr, "Connection failed\n"); // 標準エラー出力
        return 1;
    }
    freeaddrinfo(res); // DNS解決(getaddrinfo)で確保したメモリを解放

    /* HTTPリクエストの送受信の開始
    ssize_t send(int sockfd, const void *buf, size_t len, int flags) でデータを送信
    recv(sock, buffer, size, 0) で受信データを取得 */
    ssize_t sent_bytes = send(sock, REQUEST, strlen(REQUEST), 0);
    if (sent_bytes < 0) {
        perror("function 'send' failed");
        close(sock); // 送信失敗時のエラーハンドリング
        return 1;
    }

    /* 受信するHTTPレスポンスをhtmlファイルに保存するため */
    FILE *file = fopen(FILE_NAME, "w");
    if (!file) {
        perror("File open failed");
        close(sock); // ポインタfileが0,ファイルが開けなかった場合
        return 1;
    }

    /* recv関数の戻り値と引数
    ssize_t recv(int sockfd, void *buf, size_t len, int flags);
    buf: 受信データのバッファ, len: 受信する最大バイト数, flags = 0: 通常受信
    */
    ssize_t bytes_received; // recvの戻り値。受信データの長さを格納するlong型
    while ((bytes_received = recv(sock, buffer, BUFFER_SIZE - 1, 0)) > 0) {
        buffer[bytes_received] = '\0'; // 受信データを文字列として扱うため終端文字を追加
        printf("%s", buffer);  // デバッグ用に画面出力
        fprintf(file, "%s", buffer);  // ファイルに書き込む
    }
    
    /* FILE型のファイルとint型のファイルディスクリプタ(ソケット)を閉じる */
    fclose(file);
    close(sock);

    printf("\nResponse saved to a file(ooo.html)\n"); // 完了メッセージ
    return 0; // 正常終了値を返す
}