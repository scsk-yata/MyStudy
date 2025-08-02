/* wolfSSLを使用したHTTPSクライアント（HTTPSリクエスト送信とレスポンス受信）のコード *//* wolfSSLを使用したHTTPSクライアント（HTTPSリクエスト送信とレスポンス受信）のコード */
#define _GNU_SOURCE               // 構造体hostentなどのGNU固有の拡張を有効にするため。
#include <stdio.h>                // 標準入出力関数のヘッダファイル
#include <stdlib.h>               // 標準ライブラリのヘッダ（メモリ管理、プログラム終了など）
#include <string.h>               // 文字列操作関数のヘッダ
#include <unistd.h>               // POSIX標準のAPI（close関数など）のヘッダ
#include <sys/socket.h>           // ソケット通信のためのヘッダーファイル
#include <netinet/in.h>           // インターネットプロトコルファミリーの定義
#include <arpa/inet.h>            // インターネット操作のためのヘッダ（inet_ntoa関数など）
#include <netdb.h>                // ネットワークデータベース操作関数のヘッダ（gethostbyname()など）
#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/settings.h>
#include <wolfssl/ssl.h>          // wolfSSLライブラリのメインヘッダーファイル

#define HOST "www.scsk.jp"        // 接続先のホスト名
#define PORT 443                  // HTTPS通信用の標準ポート番号
#define BUFFER_SIZE 4096          // 受信バッファの最大サイズ 4GiBに設定
#define FILE_NAME "responce_from_server.html" // webサイトから受け取ったHTMLドキュメントを保存するファイル名
#define WORK_PATH "/workspaces/yatam/source/"                        // 作業ディレクトリのパス
//#define ROOT_PATH "/etc/ssl/certs/GlobalSign_Root_CA_-_R3.pem"     // ルート証明書のパス
#define ROOT_PATH "/workspaces/yatam/source/rootcacert_r3.pem"       // ルート証明書のパス
#define INTER_PATH "/workspaces/yatam/source/gsrsaovsslca2018.pem"   // 中間証明書のパス
#define SERV_PATH "/workspaces/yatam/source/scsk_server.pem"         // チェイン前の証明書のパス
#define CHAIN_PATH "/workspaces/yatam/source/scsk_chained.pem"       // チェイン後の証明書のパス
#define CERT_PATH "/workspaces/yatam/source/wolfssl/certs/"          // wolfsslの証明書フォルダのパス


int main() {
    int sock;                     // ソケットを識別するディスクリプタ
    struct sockaddr_in server_addr; // サーバーのアドレス情報を格納する構造体
    struct hostent *server;       // サーバーのホスト情報を格納する構造体
    WOLFSSL_CTX *ctx;             // wolfSSLのコンテキスト（暗号化や認証方法を管理）
    // X509証明書や圧縮方式、EVP(OpenSSLの暗号や署名機能)関数の秘密鍵に関する情報
    WOLFSSL *ssl;                 // wolfSSLのセッション（サーバとのコネクションを管理）
    // セッションID、シーケンス番号、ランダム値やマスターシークレットなどの情報
    char buffer[BUFFER_SIZE];
        const char request[] =  "GET / HTTP/1.1\r\n"
                                "Host: " HOST "\r\n"
                                "Connection: close\r\n"
                                "\r\n"; // HTTPリクエストやレスポンスは\r\nで区切る必要がある

    // wolfSSLライブラリの初期化　TLSセッションのキャッシュ削除や乱数生成器の初期化など
    if (wolfSSL_Init() != WOLFSSL_SUCCESS) {
        fprintf(stderr, "Executed function 'wolfSSL_Init' error\n"); // 失敗した場合は標準エラー出力に表示
        return 1;
    }
    // デバッグモードの有効化
    wolfSSL_Debugging_ON();


    // TLS1.3クライアント用のコンテキストを作成　暗号スイートや鍵、証明書などの情報
    // TLS 1.3では、クライアントは'ClientHello'メッセージの拡張フィールドに、鍵交換に必要なパラメータを最初から含める。
    ctx = wolfSSL_CTX_new(wolfTLSv1_3_client_method());
    if (!ctx) {
        fprintf(stderr, "Executed function 'wolfSSL_CTX_new' failed\n");
        wolfSSL_Cleanup(); // セッション確立のために確保したメモリリソースなどを解放
        return 1;
    }


// ソケットの作成 ドメインはIPv4、typeはTCPストリーム、プロトコルはデフォルト設定
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("Socket creation process failed");
        wolfSSL_CTX_free(ctx); // TLSコンテキスト構造体用に確保したメモリの解放
        wolfSSL_Cleanup();
        return 1;
    }

    // ホスト名をIPアドレスに変換
    server = gethostbyname(HOST); // netdb.hで定義された関数
    if (!server) {
        perror("Server Host was not found");
        close(sock); // 作成したソケットを閉じる
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }

    // 接続先アドレスやポート番号などのサーバー情報を設定
    memset(&server_addr, 0, sizeof(server_addr)); // server_addr構造体のメモリを確保してオールゼロクリア
    server_addr.sin_family = AF_INET;             // アドレスファミリーをIPv4に設定
    server_addr.sin_port = htons(PORT);           // ポート番号をネットワークバイトオーダーに変換して設定
    printf("PORT %d → Network Byte Order %d\n",PORT,htons(PORT));         // リトルエンディアンに変換されていることを確認用
    memcpy(&server_addr.sin_addr.s_addr, server->h_addr_list[0], server->h_length); // サーバーのIPアドレスを設定
    // 関数定義：void *memcpy(void *dest, const void *src, size_t n); in_port_t は uint16_t, in_addr_t は uint32_t

    // ソケットにserver_addressを登録。sockaddrにはネットワーク層レベルの通信プロトコルやアドレスとポート情報を格納
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Failed to Connect Socket to Server Address");
        close(sock);
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }
    
    // 証明書の検証に関する設定を行う関数
    wolfSSL_CTX_set_verify(ctx, SSL_VERIFY_PEER, NULL); // 信頼できるCAによって署名されているかを検証
    //wolfSSL_CTX_set_verify(ctx, SSL_VERIFY_NONE, NULL); // 証明書の検証を無効化する設定
    //wolfSSL_CTX_set_verify(ctx, SSL_VERIFY_FAIL_IF_NO_PEER_CERT, NULL); // エラーハンドリング



    // ルート証明書を検証に使用するため、SSLコンテクストに読み込ませる。
    int verified_root_cert = wolfSSL_CTX_load_verify_locations(ctx, ROOT_PATH, NULL);
    printf("Verified root certificate : %d\n", verified_root_cert);
    if (verified_root_cert != WOLFSSL_SUCCESS) {
        fprintf(stderr, "Loading CA certificate failed\n");
        int err = wolfSSL_ERR_get_error_line_data(NULL, NULL, NULL, NULL);
        fprintf(stderr, "wolfSSL error code: %d\n", err);
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }

     // 中間証明書を検証に使用するため、SSLコンテクストに読み込ませる。
     int verified_medium_cert = wolfSSL_CTX_load_verify_locations(ctx, INTER_PATH, NULL);
     printf("Verified intermediate certificate : %d\n", verified_medium_cert);
     if (verified_medium_cert != WOLFSSL_SUCCESS) {
         fprintf(stderr, "Loading Medium certificate failed\n");
         int err = wolfSSL_ERR_get_error_line_data(NULL, NULL, NULL, NULL);
         fprintf(stderr, "wolfSSL error code: %d\n", err);
         wolfSSL_CTX_free(ctx);
         wolfSSL_Cleanup();
         return 1;
     }

    // 結合したサーバー証明書ファイルを読み込む
    int verified_scsk_cert = wolfSSL_CTX_load_verify_locations(ctx, CHAIN_PATH, NULL);
    printf("Verified scsk certificate : %d\n", verified_scsk_cert);
    if (verified_scsk_cert != WOLFSSL_SUCCESS) {
        fprintf(stderr, "Loading scsk certificate failed\n");
        int err = wolfSSL_ERR_get_error_line_data(NULL, NULL, NULL, NULL);
        fprintf(stderr, "wolfSSL error code: %d\n", err);
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }

    // システムのCA証明書ストアを利用する場合。
    //wolfSSL_CTX_load_system_CA_certs(ctx);

    // wolfssl型の構造体sslを作成し、wolfSSLのセッションを開始
    ssl = wolfSSL_new(ctx);
    if (!ssl) {
        fprintf(stderr, "Executed function 'wolfSSL_new' failed.\n");
        close(sock);
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }

    // ソケットとwolfSSLセッションを関連付ける（ファイルディスクリプタを使用）
    if (wolfSSL_set_fd(ssl, sock) != WOLFSSL_SUCCESS) {
        fprintf(stderr, "Executed function 'wolfSSL_set_fd' failed.\n");
        wolfSSL_free(ssl);
        close(sock);
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }

    // TLSハンドシェイクの開始、暗号鍵交換、証明書認証のやり取りを始める。
    int connection = wolfSSL_connect(ssl);
    printf("connection status : %d\n", connection);

    if (connection != WOLFSSL_SUCCESS) {
        int error = wolfSSL_get_error(ssl, connection);
        char error_buffer[BUFFER_SIZE]; // エラーメッセージを格納するバッファ
        wolfSSL_ERR_error_string(error, error_buffer); // エラーメッセージを取得
        fprintf(stderr, "Executed function 'wolfSSL_connect' failed\n");
        fprintf(stderr, "connection error code : %d\n", error);
        fprintf(stderr, "Error message : %s\n", error_buffer);
        wolfSSL_free(ssl);
        close(sock);
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }

    // SSLセッションの確立後に、サーバーへHTTPリクエストを送信(writeまたはsend)
    if (wolfSSL_write(ssl, request, strlen(request)) < 0) {
        fprintf(stderr, "Executed function 'wolfSSL_write' failed\n");
        wolfSSL_free(ssl);
        close(sock);
        wolfSSL_CTX_free(ctx);
        wolfSSL_Cleanup();
        return 1;
    }


    /* 受信するHTTPレスポンスをhtmlファイルに保存するため */
    FILE *file = fopen(FILE_NAME, "w");
    if (!file) { // ファイルストリームのポインタfileが0,ファイルが開けなかった場合
        perror("Failed to open a HTML file");
        close(sock);
        return 1;
    }
 
    // HTTPレスポンスを受け取り、設定したバッファサイズ毎にコンソールに表示
    printf("Receive response from HTTP server ...\n");
    do { // wolfSSL_readはlong型のbytes_receivedを戻り値として返す。
        ssize_t bytes_received = wolfSSL_read(ssl, buffer, BUFFER_SIZE - 1);
        if (bytes_received <= 0) break;
        buffer[bytes_received] = '\0'; // 文字列として認識させるため終端文字を付与する。
        //printf("%s", buffer); // 受け取ったHTMLをコンソールに表示する。
        fprintf(file, "%s", buffer);  // 開いておいたhtmlファイルに書き込む
    } while (1);

    printf("Response was saved to a file(.html)\n"); // 完了メッセージ

    // HTMLドキュメントを受け取った後の、メモリ開放やソケットのクローズ処理
    wolfSSL_free(ssl);
    close(sock);
    wolfSSL_CTX_free(ctx);
    wolfSSL_Cleanup();
    fclose(file); // FILE型のファイルとint型のファイルディスクリプタ(ソケット)を閉じる
    return 0;
}