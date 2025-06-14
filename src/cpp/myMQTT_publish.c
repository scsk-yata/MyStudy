// MQTTパブリッシャのTLSではない通信
#include <stdio.h>      // 標準入出力用
#include <stdlib.h>     // 標準ライブラリ（exit等）
#include <string.h>     // 文字列処理用
#include "MQTTClient.h" // Paho MQTTクライアントのヘッダ

#define ADDRESS "tcp://localhost:1883" // MQTTブローカのアドレス（localhost）
#define CLIENTID "ExamplePublisher"    // このクライアントのID
#define TOPIC "iot/sensor/temp"        // パブリッシュするトピック
#define PAYLOAD "23.5"                 // 実際の送信データ（センサー値）
#define QOS 1                          // QoSレベル（0〜2）
#define TIMEOUT 10000L                 // タイムアウト（ミリ秒単位で指定）

int main()
{
    MQTTClient client;                                                           // MQTTクライアント構造体
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer; // 接続設定の開始

    int rc; // 戻り値チェック用

    // クライアントの初期化
    MQTTClient_create(&client, ADDRESS, CLIENTID, MQTTCLIENT_PERSISTENCE_NONE, NULL);

    // 接続オプションの設定
    conn_opts.keepAliveInterval = 20; // KeepAlive間隔
    conn_opts.cleansession = 1;       // クリーンセッション（再接続時に状態を持たない）

    // MQTTブローカに接続、rcに受け取ったコードを格納する
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("ブローカへの接続に失敗しました。エラーコード: %d\n", rc);
        exit(EXIT_FAILURE);
    }

    // メッセージの構造体を初期化
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    pubmsg.payload = (void *)PAYLOAD;    // 実際のデータ
    pubmsg.payloadlen = strlen(PAYLOAD); // データ長(bytes)
    pubmsg.qos = QOS;                    // QoSレベル
    pubmsg.retained = 0;                 // 保持Retainしない

    MQTTClient_deliveryToken token; // メッセージ送信確認用トークン

    // 実際にメッセージをパブリッシュ
    MQTTClient_publishMessage(client, TOPIC, &pubmsg, &token);
    printf("メッセージ送信中...\n");

    // 送信完了まで待機
    rc = MQTTClient_waitForCompletion(client, token, TIMEOUT);
    printf("メッセージが配信されました。トークン: %d, 結果: %d\n", token, rc);

    // 切断してリソース解放
    MQTTClient_disconnect(client, 10000); // TIMEOUTが1000ミリ秒
    MQTTClient_destroy(&client);
    return 0;
}
