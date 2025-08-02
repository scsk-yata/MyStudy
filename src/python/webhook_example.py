#!/usr/bin/env python3
# スクリプトがPython 3環境で実行されるよう指定しているシェバン行

# EPAM SystemsによるApache 2.0ライセンスの著作権表記（問題なく再利用可）。

import time                 # 通信間隔などのウェイト処理のためにtimeモジュールを読み込む
import json                 # JSON形式にデータを変換するためのモジュール
import datetime             # 現在時刻を取得するためのモジュール
import logging              # 実行中のログを出力するための標準ライブラリ

from urllib import request  # HTTP通信を行うためのurllib.requestをインポート

# ロガーの初期化。ログのカテゴリとして現在のモジュール名（__name__）を設定
logger = logging.getLogger(__name__)

# Webhook Site の URL（テスト用HTTPエンドポイント）
# ※ https://webhook.site にアクセスして自分専用のURLを発行すれば別のアドレスも利用可能
HTTP_REQUEST_RECEIVER_URL = "https://webhook.site/db8fe43a-1893-4897-a389-9003849ee912"

# 通信の送信間隔（秒数）
DATA_SENDING_DELAY = 2

# エラーが起きなければ待つ時間（今回は使っていない）
WAIT_TIMEOUT = 5

# 例外発生時に再試行するまでの待機時間（秒数）
DELAY_AFTER_ERROR = 2


def main():
    """
    メイン処理関数：定期的に"Hello world!"のメッセージと現在時刻を
    JSON形式で指定URLへPOSTする。
    """
    greetings = 'Hello world!'  # 送信するメッセージ本文

    # 永久ループ：終了するまで定期的にデータを送信し続ける
    while True:
        try:
            # 送信先URLをログ出力（infoレベル）
            logger.info("Sending telemetry to '{url}'".format(url=HTTP_REQUEST_RECEIVER_URL))

            # 送信するJSONデータをPythonの辞書として定義
            json_data = {
                "Unit said": greetings,                          # メッセージ本文
                "datetime": datetime.datetime.now().isoformat()  # ISO 8601形式で現在時刻を付加
            }

            # 辞書型データをJSON文字列に変換し、バイト列（UTF-8）としてエンコード
            params = json.dumps(json_data).encode('utf8')

            # HTTP POSTリクエストを作成（ヘッダーでJSONを指定）
            request_data = request.Request(
                HTTP_REQUEST_RECEIVER_URL,             # 送信先URL
                data=params,                           # POSTするバイナリデータ
                headers={'content-type': 'application/json'}  # ヘッダーでContent-TypeをJSONに指定
            )

            # リクエストを送信（レスポンスは今回は無視）
            request.urlopen(request_data)

            # 次の送信まで指定秒数だけ待機
            time.sleep(DATA_SENDING_DELAY)

        except KeyboardInterrupt:
            # Ctrl+Cなどによる割り込み時の処理（ログを出して終了）
            logger.info("Received Keyboard interrupt. shutting down")
            break

        except Exception as exc:
            # その他すべての例外をキャッチし、ログ出力
            logger.error(
                "Unhandled exception: {exc_name}".format(exc_name=exc.__class__.__name__),
                exc_info=True,  # 例外のスタックトレースも含めて出力
            )
            time.sleep(DELAY_AFTER_ERROR)  # 少し待ってから再試行
            continue


# スクリプトが直接実行された場合にmain関数を呼び出す
if __name__ == '__main__':
    main()
