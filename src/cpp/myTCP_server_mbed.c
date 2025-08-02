/* TLS対応 TCPサーバープログラム（mbedTLS使用）*/

#include <stdio.h>              // 標準入出力関数（printfなど）
#include <stdlib.h>             // 各種標準ライブラリ（exitなど）
#include <string.h>             // 文字列操作関数（memset, strlenなど）
#include <unistd.h>             // UNIX標準関数（read, write, closeなど）
#include <arpa/inet.h>          // ソケット関連（sockaddr_inなど）
#include <fcntl.h>              // ソケットをノンブロッキングにするなどの制御用
#include <sys/select.h>         // 多重I/O監視用のselect関数

// mbedTLS関連ヘッダ（SSL/TLS通信に必要）
#include "mbedtls/net_sockets.h"       // ソケット操作を抽象化する
#include "mbedtls/ssl.h"               // SSL/TLSハンドシェイクや通信
#include "mbedtls/ssl_cache.h"         // セッションキャッシュ（今回は使用せず）
#include "mbedtls/ssl_cookie.h"        // DTLS用Cookie（今回は使用せず）
#include "mbedtls/entropy.h"           // エントロピーソース（乱数の元）
#include "mbedtls/ctr_drbg.h"          // CTR方式の疑似乱数生成器
#include "mbedtls/certs.h"             // テスト用の証明書が含まれる
#include "mbedtls/error.h"             // エラーメッセージ変換ユーティリティ
#include "mbedtls/x509.h"              // 証明書構造体
#include "mbedtls/x509_crt.h"          // 証明書の操作
#include "mbedtls/pk.h"                // 秘密鍵の操作

#define SERVER_PORT "4433"              // 通信に使用するポート番号（文字列形式）
#define MAX_CLIENTS 10                  // 同時接続可能なクライアント数（今回は未使用）
#define BUFFER_SIZE 1024               // 送受信に使うバッファサイズ

int main() {
    int ret;  // 戻り値用の変数（エラー確認に使用）

    // ソケット、TLS、証明書、鍵などの構造体を宣言
    mbedtls_net_context listen_fd, client_fd; // TCP接続用のサーバ・クライアントソケット
    mbedtls_ssl_context ssl;                  // 個々のSSLセッションを表す構造体
    mbedtls_ssl_config conf;                  // SSLコンフィグ全体の設定
    mbedtls_x509_crt srvcert;                 // サーバの証明書（X.509形式）
    mbedtls_pk_context pkey;                  // サーバの秘密鍵
    mbedtls_entropy_context entropy;          // エントロピー（乱数の種）
    mbedtls_ctr_drbg_context ctr_drbg;        // 乱数生成器（CTR_DRBG）
    const char *pers = "tls_server";          // 乱数生成用のパーソナライズ文字列

    char buffer[BUFFER_SIZE];  // 通信用のバッファ

    // 各構造体の初期化
    mbedtls_net_init(&listen_fd);
    mbedtls_net_init(&client_fd);
    mbedtls_ssl_init(&ssl);
    mbedtls_ssl_config_init(&conf);
    mbedtls_x509_crt_init(&srvcert);
    mbedtls_pk_init(&pkey);
    mbedtls_entropy_init(&entropy);
    mbedtls_ctr_drbg_init(&ctr_drbg);

    // サーバ証明書の読み込み（PEM形式）
    ret = mbedtls_x509_crt_parse_file(&srvcert, "server.crt");
    if (ret != 0) {
        printf("証明書読み込みエラー\n");
        return 1;
    }

    // 秘密鍵の読み込み（パスワードなし）
    ret = mbedtls_pk_parse_keyfile(&pkey, "server.key", NULL);
    if (ret != 0) {
        printf("秘密鍵読み込みエラー\n");
        return 1;
    }

    // 乱数生成器の初期化（entropyを元に乱数を生成できるようにする）
    ret = mbedtls_ctr_drbg_seed(&ctr_drbg, mbedtls_entropy_func, &entropy,
                                (const unsigned char *)pers, strlen(pers));
    if (ret != 0) {
        printf("乱数生成器初期化失敗\n");
        return 1;
    }

    // サーバソケットを指定ポートでバインド
    ret = mbedtls_net_bind(&listen_fd, NULL, SERVER_PORT, MBEDTLS_NET_PROTO_TCP);
    if (ret != 0) {
        printf("ソケットバインド失敗\n");
        return 1;
    }

    // SSL設定の初期化（TLSサーバとして動作させる）
    ret = mbedtls_ssl_config_defaults(&conf,
        MBEDTLS_SSL_IS_SERVER,           // サーバモード
        MBEDTLS_SSL_TRANSPORT_STREAM,    // TCPベースのTLS
        MBEDTLS_SSL_PRESET_DEFAULT);     // デフォルトパラメータセット
    if (ret != 0) {
        printf("SSL設定初期化失敗\n");
        return 1;
    }

    // SSL設定にランダム関数・証明書・鍵などを登録
    mbedtls_ssl_conf_rng(&conf, mbedtls_ctr_drbg_random, &ctr_drbg);
    mbedtls_ssl_conf_ca_chain(&conf, srvcert.next, NULL);
    ret = mbedtls_ssl_conf_own_cert(&conf, &srvcert, &pkey);
    if (ret != 0) {
        printf("証明書/鍵設定失敗\n");
        return 1;
    }

    // 接続待ちループ（単一のクライアント処理）
    while (1) {
        printf("待機中...\n");

        // クライアントの接続受付
        ret = mbedtls_net_accept(&listen_fd, &client_fd, NULL, 0, NULL);
        if (ret != 0) {
            printf("接続受け入れ失敗\n");
            continue;
        }

        // SSL状態のリセット・再初期化
        mbedtls_ssl_session_reset(&ssl);
        mbedtls_ssl_setup(&ssl, &conf);

        // クライアントソケットをSSL BIOに設定
        mbedtls_ssl_set_bio(&ssl, &client_fd, mbedtls_net_send, mbedtls_net_recv, NULL);

        // TLSハンドシェイクの実行
        while ((ret = mbedtls_ssl_handshake(&ssl)) != 0) {
            if (ret != MBEDTLS_ERR_SSL_WANT_READ && ret != MBEDTLS_ERR_SSL_WANT_WRITE) {
                printf("TLSハンドシェイク失敗\n");
                break;
            }
        }

        // ハンドシェイク失敗時の処理
        if (ret != 0) {
            mbedtls_net_free(&client_fd);
            continue;
        }

        // クライアントからのデータ受信
        memset(buffer, 0, sizeof(buffer));
        ret = mbedtls_ssl_read(&ssl, (unsigned char *)buffer, sizeof(buffer) - 1);
        if (ret <= 0) {
            printf("受信失敗\n");
            mbedtls_net_free(&client_fd);
            continue;
        }

        // 受信内容の表示
        printf("受信: %s\n", buffer);

        // クライアントへの返信
        const char reply[] = "Hello TLS Client!\n";
        mbedtls_ssl_write(&ssl, (const unsigned char *)reply, strlen(reply));

        // TLSセッションの終了通知とソケットクローズ
        mbedtls_ssl_close_notify(&ssl);
        mbedtls_net_free(&client_fd);
    }

    // 通常は到達しないが、終了処理（メモリ解放）
    mbedtls_net_free(&listen_fd);
    mbedtls_x509_crt_free(&srvcert);
    mbedtls_pk_free(&pkey);
    mbedtls_ssl_free(&ssl);
    mbedtls_ssl_config_free(&conf);
    mbedtls_ctr_drbg_free(&ctr_drbg);
    mbedtls_entropy_free(&entropy);

    return 0;
}
