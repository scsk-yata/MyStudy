/* OpenSSLを用いてwww.scsk.jpからHTMLファイルを取得するプログラム */
#define _GNU_SOURCE
#include <stdio.h>      // 標準入出力（printf, fprintf, fopen など）を使用するためのライブラリ
#include <stdlib.h>     // メモリ管理や exit() 関数を使用するためのライブラリ
#include <string.h>     // 文字列操作（strlen, strcpy, memcpy など）を使用するためのライブラリ
#include <unistd.h>     // UNIX標準のシステムコール（read, write, close など）を使用するためのライブラリ
#include <arpa/inet.h>  // ネットワーク関連（inet_addr, htons など）の関数を使用するためのライブラリ
#include <netdb.h>      // DNS解決（gethostbyname など）を行うためのライブラリ

#include <sys/socket.h> // ソケット関連の関数
#include <netinet/in.h> // sockaddr_in 型構造体を使うため。

#include <openssl/ssl.h>  // OpenSSLのSSL/TLS通信ライブラリ
#include <openssl/err.h>  // OpenSSLのエラーハンドリング

// 定数の定義（変更しやすくするため、マクロを使用）
#define HOST "www.scsk.jp"  // 接続先のWebサーバーのドメイン名
#define PORT 443              // HTTPの標準ポート番号（HTTPSなら443を使用）
#define BUFFER_SIZE 4096      // 受信バッファのサイズ（一度に受け取る最大データ量）


// 送信するHTTPリクエスト（GETメソッドを使用） \で改行
#define REQUEST "GET / HTTP/1.1\r\n"\
                "Host: " HOST "\r\n"\
                "Connection: close\r\n"\
                "\r\n"

int main() {
    int sock;  // ファイルディスクリプタ(ソケットの識別子)として機能
    struct sockaddr_in server_addr; // 接続先のサーバー情報（IPv4アドレスとポート）
    struct hostent *server; // gethostbyname() の戻り値（ホスト情報）を格納するポインタ
    SSL_CTX *ctx; // OpenSSLのコンテキスト
    SSL *ssl; // SSLセッション用構造体

    char buffer[BUFFER_SIZE]; // サーバーからのレスポンスデータを一時的に格納するバッファ


    // OpenSSLの初期化
    SSL_library_init();  // SSLライブラリの初期化
    OpenSSL_add_all_algorithms(); // 暗号アルゴリズムを登録
    SSL_load_error_strings(); // エラーメッセージのロード

    // TLSクライアント用のコンテキストを作成
    ctx = SSL_CTX_new(TLS_client_method());
    if (!ctx) {
        fprintf(stderr, "SSL_CTX_new error\n");
        return 1;
    }

    // ソケットの作成（IPv4, タイプはストリーム、プロトコルはTCP）
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("Socket creation failed");
        SSL_CTX_free(ctx);
        return 1;
    }

    // ソケットに送受信のタイムアウトを設定する。
    struct timeval timeout;
    timeout.tv_sec = 10;  // 10秒のタイムアウト
    timeout.tv_usec = 0;
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (const char*)&timeout, sizeof(timeout));


    // ホスト名をIPアドレスに変換 gethostbynameは非推奨なのでgetaddrinfoも使えるように
    if ((server = gethostbyname(HOST)) == NULL) {
        perror("Host not found");
        close(sock);
        SSL_CTX_free(ctx);
        return 1;
    }

    // サーバーのアドレス情報を設定
    memset(&server_addr, 0, sizeof(server_addr)); // 構造体メンバのメモリをゼロクリア
    server_addr.sin_family = AF_INET; // IPv4アドレスファミリー
    server_addr.sin_port = htons(PORT); // ポート番号をネットワークバイトオーダーに変換（ビッグエンディアンへ）
    memcpy(&server_addr.sin_addr.s_addr, server->h_addr_list[0], server->h_length); // hostent * → sockaddr_inへ

    // 作成したソケットをサーバーへ接続
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Connection failed");
        close(sock);
        SSL_CTX_free(ctx);
        return 1;
    }

    // SSLコンテキストを基にSSLセッションの作成
    ssl = SSL_new(ctx);
    if (!ssl) {
        fprintf(stderr, "SSL_new error\n");
        close(sock);
        SSL_CTX_free(ctx);
        return 1;
    }

    // ソケットをSSLオブジェクトに関連付け
    SSL_set_fd(ssl, sock);

    // TLSハンドシェイクの開始
    if (SSL_connect(ssl) != 1) {
        fprintf(stderr, "SSL_connect failed\n");
        ERR_print_errors_fp(stderr);  // OpenSSLのエラースタックを表示
        SSL_free(ssl);
        close(sock);
        SSL_CTX_free(ctx);
        return 1;
    }
    

    // HTTPSリクエストの送信
    if (SSL_write(ssl, REQUEST, strlen(REQUEST)) <= 0) {
        fprintf(stderr, "SSL_write failed\n");
        SSL_free(ssl);
        close(sock);
        SSL_CTX_free(ctx);
        return 1;
    }

    
    // サーバーからのレスポンスを受信し、ファイルに保存
    FILE *file = fopen("response.html", "w"); // 受信データを保存するファイルを開く
    if (file == NULL) {
        perror("File open failed"); // ファイルオープン失敗時のエラーメッセージ
        return 1;
    }

    // HTTPSレスポンスの受信
    printf("Response from server\n\n");
    while (1) {
        int bytes_received = SSL_read(ssl, buffer, BUFFER_SIZE - 1);
        if (bytes_received <= 0) break;
        buffer[bytes_received] = '\0'; // 受信データを文字列として扱うために終端文字を追加
        //snprintf(buffer, BUFFER_SIZE, "%s",buffer); // 安全なバッファ処理の実現
        printf("%s", buffer);
        fprintf(file,"%s", buffer);
    }

    // HTTPS通信が終わった後のメモリガーベッジ
    SSL_free(ssl); // SSLセッション用のメモリ解放
    close(sock); // ソケットクローズ
    SSL_CTX_free(ctx); // SSLコンテキスト解放
    ERR_free_strings(); // OpenSSLのエラー情報を解放
    fclose(file); // HTML記録用ファイルをクローズ
    return 0;
}