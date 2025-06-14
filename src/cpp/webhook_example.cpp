/* webhook_example.cpp */

// 必要な標準ライブラリのインクルード
#include <iostream>     // 標準入出力
#include <string>       // 文字列操作
#include <ctime>        // 時刻取得
#include <chrono>       // 高精度時間処理
#include <thread>       // スリープ処理
#include <curl/curl.h>  // HTTP通信ライブラリ libcurl
#include <sstream>      // 文字列ストリーム
#include <iomanip>      // 時間整形
#include <csignal>      // シグナル制御

// グローバル変数。ループ継続判定に使用
bool keepRunning = true;

// シグナルハンドラ関数 (Ctrl+Cなどで呼ばれる)
// SIGINTを受信した場合にループを停止する
void signalHandler(int signal) {
    if (signal == SIGINT) {  // キーボード割り込み(Ctrl+C)
        std::cout << "Received Keyboard Interrupt. Shutting down..." << std::endl;
        keepRunning = false;  // ループを止める
    }
}

// ISO8601形式（2024-01-01T12:00:00Z）の現在時刻を取得する関数
std::string getCurrentTimeISO8601() {
    auto now = std::chrono::system_clock::now();                    // 現在時刻を取得（高精度）
    std::time_t now_time = std::chrono::system_clock::to_time_t(now); // time_t形式に変換
    std::tm* tm_ptr = std::gmtime(&now_time);                         // UTC(協定世界時)に変換

    std::ostringstream oss;
    oss << std::put_time(tm_ptr, "%Y-%m-%dT%H:%M:%SZ");               // ISO8601形式に整形
    return oss.str();
}

int main() {
    // 通信先Webhook URL
    const std::string url = "https://webhook.site/db8fe43a-1893-4897-a389-9003849ee912";
    // 送信間隔（秒）
    const int send_delay_sec = 2;
    // エラー時のリトライ間隔（秒）
    const int retry_delay_sec = 2;

    // Ctrl+C などの割り込み時に signalHandler を呼び出すよう登録
    std::signal(SIGINT, signalHandler);

    CURL* curl;
    CURLcode res;

    // libcurl全体の初期化
    curl_global_init(CURL_GLOBAL_DEFAULT);
    // 通信用のCURLハンドル作成
    curl = curl_easy_init();

    // ハンドル作成失敗時のチェック
    if (!curl) {
        std::cerr << "Failed to initialize libcurl" << std::endl;
        return 1;
    }

    // メインループ（SIGINTを受け取るまで継続）
    while (keepRunning) {
        // 送信するJSON形式のペイロードを作成
        // 現在時刻を含めることでリアルタイムデータをシミュレート
        std::string json_payload = 
            "{\"Unit said\": \"Hello world!\", \"datetime\": \"" + getCurrentTimeISO8601() + "\"}";

        // 送信先URL設定
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        // POSTデータ（JSON）設定
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, json_payload.c_str());

        // HTTPヘッダー設定（Content-Typeをapplication/jsonに設定）
        struct curl_slist* headers = nullptr;
        headers = curl_slist_append(headers, "Content-Type: application/json");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

        // 送信開始メッセージ
        std::cout << "Sending telemetry to '" << url << "'" << std::endl;
        // 通信実行（POSTリクエスト送信）
        res = curl_easy_perform(curl);

        // エラー判定
        if (res != CURLE_OK) {
            // エラー内容を標準エラー出力に表示
            std::cerr << "curl error: " << curl_easy_strerror(res) << std::endl;
            // エラー時はリトライ間隔だけ待機し、次のループへ
            std::this_thread::sleep_for(std::chrono::seconds(retry_delay_sec));
            continue;
        }

        // 送信成功時は次回送信まで待機
        std::this_thread::sleep_for(std::chrono::seconds(send_delay_sec));
    }

    // 後片付け
    curl_easy_cleanup(curl);         // 通信用ハンドル解放
    curl_global_cleanup();           // libcurl全体の終了処理
    return 0;
}
