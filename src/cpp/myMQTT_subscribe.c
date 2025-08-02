#include <stdio.h>                      // 標準入出力関数（printfなど）
#include <stdlib.h>                     // 標準ライブラリ関数（exitなど）
#include <string.h>                     // 文字列処理（strlenなど）
#include "MQTTClient.h"                 // Eclipse Paho MQTT C Clientのヘッダファイル（サードパーティ製）
                                        // 公式サイト: https://www.eclipse.org/paho/clients/c/

#define ADDRESS     "tcp://localhost:1883" // MQTTブローカの接続先アドレス（今回はローカルホスト）
#define CLIENTID    "ExampleSubscriber"    // MQTTクライアントID（重複しないユニークな名前）
#define TOPIC       "iot/sensor/temp"      // サブスクライブ対象のトピック名（このトピックに届くメッセージを受信）
#define QOS         1                      // Quality of Serviceレベル（1: 少なくとも1回配送）
#define TIMEOUT     10000L                 // タイムアウト（ミリ秒）→一部APIの待機時間などに使用

// メッセージ受信時に自動的に呼ばれるコールバック関数
int messageArrived(void *context, char *topicName, int topicLen, MQTTClient_message *message) {
    // MQTTブローカからメッセージを受信した際に呼ばれる
    printf("メッセージ受信！\nトピック: %s\n内容: %.*s\n",
           topicName,                          // 受信したトピック名を表示
           message->payloadlen,               // メッセージの長さを指定
           (char*)message->payload);          // ペイロードデータ本体（void* を char* にキャストして出力）
           // このように `printf("%.*s", len, data)` とすることで、終端文字（\0）がなくても正確に表示可能

    // メモリ解放（Pahoライブラリで確保されたデータ領域を自前で開放)
    MQTTClient_freeMessage(&message);         // メッセージ構造体に確保されたメモリを解放
    MQTTClient_free(topicName);               // トピック名（文字列）のメモリも解放

    return 1; // 正常処理終了を通知（非ゼロで次のメッセージも受信）
}

int main() {
    MQTTClient client;                        // MQTTクライアント構造体
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;  
                                              // 接続オプション構造体（初期化マクロで設定）

    int rc;                                   // rcは "Return Code" または "Result Code" の略
                                              // 関数の戻り値（正常/異常）を保持するために使われる慣習的変数名

    MQTTClient_create(&client, ADDRESS, CLIENTID, MQTTCLIENT_PERSISTENCE_NONE, NULL);
    // MQTTクライアントを初期化・生成する関数
    // 第1引数: クライアント構造体のポインタ
    // 第2引数: 接続アドレス（tcp://host:port形式）
    // 第3引数: クライアントID（ユニークな識別子）
    // 第4引数: 永続性（PERSISTENCE_NONE = セッション状態などは保存しない）
    // 第5引数: コンテキスト（NULLでOK）

    conn_opts.keepAliveInterval = 20;         // サーバへ疎通確認用 "PINGREQ" を送る間隔（秒単位）
                                              // クライアントが一定時間通信しない場合にブローカが切断しないように定期的にPING送信

    conn_opts.cleansession = 1;               // "Clean Session" フラグ（1 = セッション情報を保持しない）
                                              // 前回のサブスクライブ状態を保持せずに、毎回新規セッションを開始する設定

    MQTTClient_setCallbacks(client, NULL, NULL, messageArrived, NULL);
    // クライアントに対するコールバック関数を設定
    // 第1引数: クライアント
    // 第2引数: connectionLost（接続断処理）→ NULL（未使用）
    // 第3引数: deliveryComplete（送信完了通知）→NULL（未使用）
    // 第4引数: messageArrived（受信時の処理関数） main外で定義済み
    // 第5引数: context → 共有データ用（NULLでOK）

    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS) {
        // MQTTサーバーに接続を試みる。戻り値がMQTTCLIENT_SUCCESS（=0）以外なら失敗
        printf("接続失敗: %d\n", rc);          // エラーコードを表示
        exit(EXIT_FAILURE);                    // 異常終了
    }

    printf("トピック '%s' にサブスクライブします...\n", TOPIC);
    MQTTClient_subscribe(client, TOPIC, QOS);  // トピックに対してサブスクライブ開始

    // メッセージ受信を待ち続ける無限ループ（Ctrl+Cで停止）
    while(1) {
        sleep(1);                              // 無駄なCPU使用を防ぐため1秒スリープ
    }

    // 通常は到達しないが、安全のため切断処理も記述
    MQTTClient_disconnect(client, 10000);      // 接続を切断（10秒待機）
    MQTTClient_destroy(&client);               // クライアント構造体のリソース解放
    return 0;                                  // 正常終了
}