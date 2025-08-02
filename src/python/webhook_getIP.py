#!/usr/bin/env python3
# ↑ Pythonインタプリタを指定。Unix系環境でこのスクリプトを直接実行できるようにするための指定。

# 以下はライセンス情報。Apache License 2.0の下でこのコードは配布されていることを示す。
# この部分は著作権上必要な情報で、著作権者・使用条件・免責事項を明示している。

# ライブラリのインポート

import time                     # 時間処理（sleepなど）を行うライブラリ
import json                     # JSON形式のデータを作成・処理するためのライブラリ
import datetime                 # 日付や時刻を扱うライブラリ（現在時刻の取得に使用）
import logging                  # ログ出力のための標準ライブラリ
import socket                   # ホスト名やIPアドレス取得など、ネットワーク機能に使用

from urllib import request      # HTTPリクエストを送信するためのライブラリ（urllib.request）

# ロガー（ログ記録装置）を取得。モジュール名に基づいてログ出力設定
logger = logging.getLogger(__name__)

# Webhook.siteなどで生成した一意のURLに、HTTP POSTでデータを送信する
HTTP_REQUEST_RECEIVER_URL = "https://webhook.site/"

# データ送信の間隔（秒）
DATA_SENDING_DELAY = 2

# 使用されていないが、接続待機などに使える定数（秒）
WAIT_TIMEOUT = 5

# 例外が発生した場合の待機時間（秒）
DELAY_AFTER_ERROR = 2


# メイン処理関数
def main():
    # Webhookに送信する固定文字列（挨拶文）
    greetings = 'Hello world!'

    # ホスト名（PC名やデバイス名）を取得
    hostname = socket.gethostname()

    # 無限ループでデータ送信処理を継続
    while True:
        try:
            # ホスト名からIPアドレスを取得
            ip_addr = socket.gethostbyname(hostname)

            # ログに送信先のURLを出力（INFOレベル）
            logger.info("Sending telemetry to '{url}'".format(url=HTTP_REQUEST_RECEIVER_URL))

            # 送信するデータを辞書形式で構成（JSON形式へ変換する）
            json_data = {
                "Unit said": greetings,                           # 固定のメッセージ
                "datetime": datetime.datetime.now().isoformat(),  # 現在時刻（ISO8601形式）
                "hostname": hostname,                             # ホスト名
                "ip": ip_addr                                     # IPアドレス
            }

            # JSONをバイト列にエンコード（UTF-8形式）
            params = json.dumps(json_data).encode('utf8')

            # HTTP POSTリクエストを構成（ヘッダー付き）
            request_data = request.Request(
                HTTP_REQUEST_RECEIVER_URL,                     # 送信先URL
                data=params,                                   # 送信するJSONデータ（バイナリ形式）
                headers={'content-type': 'application/json'}   # Content-TypeヘッダーでJSONを明示
            )

            # 実際にHTTPリクエストを送信
            request.urlopen(request_data)

            # 一定時間待機して次の送信タイミングを待つ
            time.sleep(DATA_SENDING_DELAY)

        except KeyboardInterrupt:
            # Ctrl+C などで中断された場合、ログを出力して終了
            logger.info("Received Keyboard interrupt. shutting down")
            break

        except Exception as exc:
            # その他すべての例外を補足してログに出力（スタックトレース付き）
            logger.error(
                "Unhandled exception: {exc_name}".format(exc_name=exc.__class__.__name__),
                exc_info=True,  # 詳細な例外情報（traceback）を含める
            )
            # エラー後は一定時間待ってから再実行
            time.sleep(DELAY_AFTER_ERROR)
            continue

# Pythonスクリプトとして直接実行された場合に main() を呼び出す
if __name__ == '__main__':
    main()