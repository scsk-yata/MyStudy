#include <stdio.h>      // 標準入出力（printf, perror）
#include <stdlib.h>     // exit, malloc など
#include <string.h>     // 文字列処理
#include <unistd.h>     // close など
#include <errno.h>      // エラーコード用

// mbedTLS ヘッダ群
#include "mbedtls/net_sockets.h"     // TCPソケットラッパー
#include "mbedtls/ssl.h"             // TLSセッション管理
#include "mbedtls/ssl_ciphersuites.h"
#include "mbedtls/ctr_drbg.h"        // 擬似乱数生成器
#include "mbedtls/entropy.h"         // エントロピー収集
#include "mbedtls/x509_crt.h"        // 証明書構造体
#include "mbedtls/error.h"           // エラーメッセージ出力

#define SERVER_ADDR "127.0.0.1"       // サーバーアドレス（localhost）
#define SERVER_PORT "4433"           // サーバーTLSポート
#define BUFFER_SIZE 1024             // バッファサイズ

int main() {
    int ret;
    char buffer[BUFFER_SIZE];        // 送受信用バッファ
    const char *pers = "tls_client"; // 乱数生成識別子

    // mbedTLSの各構造体を初期化
    mbedtls_net_context server_fd;
    mbedtls_ssl_context ssl;
    mbedtls_ssl_config conf;
    mbedtls_ctr_drbg_context ctr_drbg;
    mbedtls_entropy_context entropy;
    mbedtls_x509_crt cacert;

    mbedtls_net_init(&server_fd);      // TCPコネクション用
    mbedtls_ssl_init(&ssl);            // TLSセッション状態
    mbedtls_ssl_config_init(&conf);    // TLSコンフィグ
    mbedtls_ctr_drbg_init(&ctr_drbg);  // 擬似乱数生成器
    mbedtls_entropy_init(&entropy);    // エントロピー
    mbedtls_x509_crt_init(&cacert);    // CA証明書読み込み用

    // CA証明書を読み込み（自己署名サーバ用）
    ret = mbedtls_x509_crt_parse_file(&cacert, "server.crt");
    if (ret < 0) {
        printf("証明書読み込み失敗\n");
        return 1;
    }

    // 乱数生成器を初期化
    ret = mbedtls_ctr_drbg_seed(&ctr_drbg, mbedtls_entropy_func, &entropy,
                                (const unsigned char *)pers, strlen(pers));
    if (ret != 0) {
        printf("DRBG初期化失敗\n");
        return 1;
    }

    // TLS設定のデフォルト値を適用
    ret = mbedtls_ssl_config_defaults(&conf,
        MBEDTLS_SSL_IS_CLIENT, MBEDTLS_SSL_TRANSPORT_STREAM, MBEDTLS_SSL_PRESET_DEFAULT);
    if (ret != 0) {
        printf("SSL config初期化失敗\n");
        return 1;
    }

    // 認証ルートCAの設定
    mbedtls_ssl_conf_authmode(&conf, MBEDTLS_SSL_VERIFY_REQUIRED); // サーバ証明書を検証
    mbedtls_ssl_conf_ca_chain(&conf, &cacert, NULL);               // CAチェイン
    mbedtls_ssl_conf_rng(&conf, mbedtls_ctr_drbg_random, &ctr_drbg);

    // SSLセッションの初期化
    mbedtls_ssl_setup(&ssl, &conf);
    mbedtls_ssl_set_hostname(&ssl, "localhost"); // SNI（Server Name Indication）

    // サーバへ接続（TCP）
    ret = mbedtls_net_connect(&server_fd, SERVER_ADDR, SERVER_PORT, MBEDTLS_NET_PROTO_TCP);
    if (ret != 0) {
        printf("接続失敗\n");
        return 1;
    }

    // SSL接続をソケットに関連付け
    mbedtls_ssl_set_bio(&ssl, &server_fd, mbedtls_net_send, mbedtls_net_recv, NULL);

    // TLSハンドシェイク
    while ((ret = mbedtls_ssl_handshake(&ssl)) != 0) {
        if (ret != MBEDTLS_ERR_SSL_WANT_READ && ret != MBEDTLS_ERR_SSL_WANT_WRITE) {
            printf("TLSハンドシェイク失敗\n");
            return 1;
        }
    }

    // メッセージ送信
    const char *msg = "Hello, TLS Server!";
    ret = mbedtls_ssl_write(&ssl, (const unsigned char *)msg, strlen(msg));
    if (ret < 0) {
        printf("送信エラー\n");
        return 1;
    }

    // 応答受信
    memset(buffer, 0, sizeof(buffer));
    ret = mbedtls_ssl_read(&ssl, (unsigned char *)buffer, sizeof(buffer) - 1);
    if (ret <= 0) {
        printf("受信エラー\n");
    } else {
        printf("受信: %s\n", buffer);
    }

    // 通信終了
    mbedtls_ssl_close_notify(&ssl);
    mbedtls_net_free(&server_fd);
    mbedtls_ssl_free(&ssl);
    mbedtls_ssl_config_free(&conf);
    mbedtls_ctr_drbg_free(&ctr_drbg);
    mbedtls_entropy_free(&entropy);
    mbedtls_x509_crt_free(&cacert);

    return 0;
}
