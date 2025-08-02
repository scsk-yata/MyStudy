// 標準入出力ライブラリをインクルード（printfなどを使用するため）
#include <stdio.h>

// 標準ライブラリをインクルード（mallocやexitなどを使用するため）
#include <stdlib.h>

// IDLから生成された型定義・メタ情報を含むヘッダ（HelloWorldData構造体や型記述子が定義）
#include "HelloWorldData.h"

// Cyclone DDSのC APIを提供するヘッダファイル
#include "dds/dds.h"

int main() {
  dds_entity_t participant, topic, writer; // DDSのエンティティ型（DomainParticipant, Topic, Writer）
  dds_return_t rc; // 戻り値値格納用変数を宣言

  // DDSドメインへの参加（DomainParticipantの作成）
  // DDS_DOMAIN_DEFAULT: デフォルトのドメイン（通常は0）を使用
  // NULL, NULL: デフォルトのQoS設定とリスナ設定を使用
  participant = dds_create_participant(DDS_DOMAIN_DEFAULT, NULL, NULL);

  // DomainParticipantの生成に失敗した場合、エラー出力して終了
  if (participant < 0) {
    fprintf(stderr, "dds_create_participant: %s\n", dds_strretcode(participant));
    return 1;
  }

  // トピック(データの「型」＋「名前」 Pub/Sub間の共有対象を定義)
  // 第2引数 &HelloWorldData_desc はIDLコンパイルで生成された型記述子（TypeSupport）
  // 第3引数 "HelloWorldTopic" はトピック名（Pub/Sub間で一致していれば通信可能）
  topic = dds_create_topic(participant, &HelloWorldData_desc, "HelloWorldTopic", NULL, NULL);
  if (topic < 0) {
    fprintf(stderr, "dds_create_topic: %s\n", dds_strretcode(topic));
    return 1;
  }

  // データライター（DataWriter）の作成
  // Pub側の実体。特定のトピックに対してデータを書き込む（=配信）
  writer = dds_create_writer(participant, topic, NULL, NULL);
  if (writer < 0) {
    fprintf(stderr, "dds_create_writer: %s\n", dds_strretcode(writer));
    return 1;
  }

  // 送信するデータの作成
  // HelloWorldData 構造体に文字列を代入（message は IDLに基づくメンバ変数）
  HelloWorldData msg;
  msg.message = "Hello from Cyclone DDS Publisher!";  // ポインタ代入。文字列リテラルは静的に割り当て

  // メッセージ内容を表示（確認用に送信前ログを出力）
  printf("送信中: %s\n", msg.message);

  // メッセージの送信
  // writerを通じてトピック上にデータを送信（pub/subモデルにおける“書き込み”）
  // &msg は送信するデータへのポインタ
  rc = dds_write(writer, &msg);
  if (rc < 0) {
    fprintf(stderr, "dds_write: %s\n", dds_strretcode(rc));
    return 1;
  }

  // データ送信後の待機時間
  // dds_sleepfor はDDSのユーティリティ関数で、ここでは1000ミリ秒（1秒）待機
  // Publisherのプロセスが即終了するとデータがネットワークに流れきらない恐れあり
  dds_sleepfor(DDS_MSECS(1000));

  // エンティティの削除・クリーンアップ
  // participantを削除すると配下のwriter/topicも自動的に削除
  dds_delete(participant);

  return 0;
}