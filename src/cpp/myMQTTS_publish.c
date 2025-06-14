// MQTTパブリッシャのTLS通信
#include <stdio.h>                      // 標準入出力関数
#include <stdlib.h>                     // 標準ライブラリ関数
#include <string.h>                     // 文字列処理
#include "MQTTClient.h"                 // Eclipse Paho MQTT C Client ヘッダ

// ssl/tls接続設定
#define ADDRESS     "ssl://test.mosquitto.org:8883"  // TLS対応ブローカのアドレス
#define CLIENTID    "TLSExampleSubscriber"           // クライアントID（送信側と別にする）
#define TOPIC       "iot/secure/temp"                // サブスクライブするトピック名
#define QOS         1                                // QoSレベル（1→少なくとも1回は配送）

// 受信時に呼ばれるコールバック関数
// ブローカからメッセージを受信する度に自動的に呼ばれる
int messageArrived(void *context, char *topicName, int topicLen, MQTTClient_message *message) {
    printf("メッセージを受信しました\n");
    printf("トピック: %s\n", topicName);                                    // 受信したトピック表示
    printf("内容: %.*s\n", message->payloadlen, (char*)message->payload);   // ペイロード分だけ表示

    // メモリ解放
    MQTTClient_freeMessage(&message);    // メッセージ構造体のメモリを解放
    MQTTClient_free(topicName);          // トピック名(文字列)バッファも解放
    return 1;                            // 処理成功を通知（1を返す）
}

int main() {
    // MQTTクライアントおよび接続オプション
    MQTTClient client;                                      // MQTTクライアント構造体
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer; // 接続オプション
    MQTTClient_SSLOptions ssl_opts = MQTTClient_SSLOptions_initializer;          // TLS用オプション

    int rc; // エラーチェック用 Return Cord

    // MQTTクライアントの作成
    MQTTClient_create(&client, ADDRESS, CLIENTID, MQTTCLIENT_PERSISTENCE_NONE, NULL);
    // 引数: クライアント構造体, 接続先アドレス, クライアントID, 永続性設定, NULL（ユーザデータ）

    // KeepAliveやCleanSessionの設定
    conn_opts.keepAliveInterval = 20;   // KeepAlive（ping間隔）20秒
    conn_opts.cleansession = 1;         // CleanSession（再接続時の状態クリア）

    // SSL/TLSの設定
    ssl_opts.enableServerCertAuth = 1;              // サーバ証明書の検証を行う
    ssl_opts.trustStore = NULL;                     // NULLの場合、OSの標準CAストアを利用
    ssl_opts.verify = 1;                            // サーバ名の検証を有効化
    ssl_opts.sslVersion = MQTT_SSL_VERSION_TLS_1_2; // TLS1.2を使用

    conn_opts.ssl = &ssl_opts; // SSL/TLSオプションを接続設定に反映

    // コールバック関数の登録
    MQTTClient_setCallbacks(client, NULL, NULL, messageArrived, NULL);
    // context, connectionLostは不要なのでNULL, messageArrived関数のみ登録

    // MQTTブローカへのTLS接続
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS) {
        // 失敗時の標準出力設定
        printf("TLS接続に失敗しました。エラーコード: %d\n", rc);
        exit(EXIT_FAILURE);
    }

    printf("TLS接続成功\n");

    // 接続確立後にトピックの購読設定
    MQTTClient_subscribe(client, TOPIC, QOS);
    printf("トピック '%s' にサブスクライブしました\n", TOPIC);

    // メッセージ待機ループ
    // ここではCtrl+Cで強制終了するまでメッセージを受信し続ける
    while(1) {
        sleep(1); // 負荷軽減のため1秒待機
    }

    // 終了処理（通常はCtrl+Cで抜けるので到達しない）
    MQTTClient_disconnect(client, 10000);  // ミリ秒単位でtimeoutの設定
    MQTTClient_destroy(&client); // 
    return 0;
}