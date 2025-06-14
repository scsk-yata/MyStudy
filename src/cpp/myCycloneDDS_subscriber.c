// 標準入出力ライブラリをインクルード（printfなどの入出力に必要）
#include <stdio.h>

// 標準ライブラリをインクルード（exitやmallocなどが使える）
#include <stdlib.h>

// IDLから生成された型情報（構造体HelloWorldDataとその記述子）をインクルード
#include "HelloWorldData.h"

// Cyclone DDSのC API定義を含むヘッダファイル
#include "dds/dds.h"

int main() {
  // Cyclone DDSのエンティティ（参加者、トピック、リーダー）と戻り値用変数を定義
  dds_entity_t participant, topic, reader;
  dds_return_t rc;

  // HelloWorldData型の変数。受信したデータが格納される
  HelloWorldData msg;

  // DDS APIではvoid*型の配列としてデータの受け渡しを行う（ポインタ配列）
  void *samples[1];

  // サンプルに関するメタ情報（valid_dataかどうかなど）を格納する構造体
  dds_sample_info_t infos[1];

  // DDSドメインへの参加
  // デフォルトドメイン（通常は0）にDomainParticipantとして参加
  participant = dds_create_participant(DDS_DOMAIN_DEFAULT, NULL, NULL);
  if (participant < 0) {
    fprintf(stderr, "dds_create_participant: %s\n", dds_strretcode(participant));
    return 1;
  }

  // トピック（Topic）の作成
  // Publisherと同じ名前・型記述子のトピックを作成（マッチする必要あり）
  topic = dds_create_topic(participant, &HelloWorldData_desc, "HelloWorldTopic", NULL, NULL);
  if (topic < 0) {
    fprintf(stderr, "dds_create_topic: %s\n", dds_strretcode(topic));
    return 1;
  }

  // データリーダー（DataReader）の作成
  // 特定トピックを購読するエンティティを作成（受信専用）
  reader = dds_create_reader(participant, topic, NULL, NULL);
  if (reader < 0) {
    fprintf(stderr, "dds_create_reader: %s\n", dds_strretcode(reader));
    return 1;
  }

  // データ格納用のサンプル配列の先頭要素にmsgのアドレスを設定
  // Cyclone DDSでは void* 配列に構造体へのポインタを登録しておく
  samples[0] = &msg;

  // データ受信（ブロッキング or 非ブロッキング）
    printf("受信待機中...\n"); // 通信ログとして受信待機中の旨を表示

  // dds_take(): データを取り出すAPI（ブロッキングなし）
  // 第1引数: リーダー
  // 第2引数: データ格納先（ポインタ配列）
  // 第3引数: サンプル情報格納先（valid_dataなど）
  // 第4引数: 最大取得数
  // 第5引数: 取得条件（DDS_ANY_STATE = 全ての状態を取得）
  rc = dds_take(reader, samples, infos, 1, DDS_ANY_STATE);

  // 有効なデータがあれば表示
  if (rc > 0 && infos[0].valid_data) {
    // 受信成功時のログ
    printf("受信: %s\n", msg.message);
  } else {
    // データが取得できなかった場合
    printf("データがありませんでした。\n");
  }

  // 終了処理 エンティティの削除
  // DomainParticipantを削除すると、配下のTopicやReaderも再帰的に削除される
  dds_delete(participant);

  return 0;
}
