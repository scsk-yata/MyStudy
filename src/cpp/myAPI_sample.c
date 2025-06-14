#include <stdio.h>          // 標準入出力（printfなど）
#include <stdlib.h>         // メモリ管理（malloc, free）やexit()など
#include <string.h>         // 文字列処理関数（strdupなど）
#include <curl/curl.h>      // libcurlの主要関数を提供するヘッダ

// HTTPレスポンスのデータ格納用構造体
struct MemoryStruct {
    char *memory;   // 受信データ本体へのポインタ
    size_t size;    // 現在の受信データサイズを格納する
};

// 書き込みコールバック関数：libcurlがHTTPレスポンスを受信するたびに呼び出される
static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
    size_t realsize = size * nmemb;   // 実際のバイト数（size × 要素数）
    struct MemoryStruct *mem = (struct MemoryStruct *)userp; // コールバック関数で渡された構造体へのポインタを取得

    // 受信データを格納するために受信データ分だけ再確保（realloc）する
    char *ptr = realloc(mem->memory, mem->size + realsize + 1); // +1はNULL終端用に1byte確保するため
    if (ptr == NULL) {
        fprintf(stderr, "メモリ再確保に失敗しました\n");
        return 0;
    }
    // MemoryStruct型の構造体mem
    mem->memory = ptr;                               // 新しいポインタを構造体に保存
    memcpy(&(mem->memory[mem->size]), contents, realsize); // 受信データをバッファの末尾にコピー
    mem->size += realsize;                           // データサイズを更新
    mem->memory[mem->size] = 0;                      // 終端にNULL文字を追加

    return realsize;                                 // 処理したバイト数を返す（これがlibcurlへの返答となる）
}

int main(void)
{
    CURL *curl_handle;             // CURLハンドル（libcurlのセッション管理）
    CURLcode res;                  // CURL関数の戻り値格納用

    struct MemoryStruct chunk;     // レスポンスデータを格納する構造体インスタンスを作成

    chunk.memory = malloc(1);      // 最初は1バイトだけ確保（NULL終端用に必須）
    chunk.size = 0;                // 受信データはまだ空（初期化）

    curl_global_init(CURL_GLOBAL_ALL); // libcurlのグローバル初期化（スレッドやSSLなど）

    curl_handle = curl_easy_init();    // セッション初期化と共に、CURLハンドルの取得
    if (!curl_handle) {
        fprintf(stderr, "curl_easy_init() に失敗しました\n");
        return 1;
    }

    // 送信するURLを指定（JSON Placeholderのコードテスト用REST API）
    curl_easy_setopt(curl_handle, CURLOPT_URL, "https://jsonplaceholder.typicode.com/todos/1");

    // User-Agentヘッダを明示的に設定（多くのAPIで必須）
    curl_easy_setopt(curl_handle, CURLOPT_USERAGENT, "libcurl-agent/1.0");

    // データの書き込み処理に使うコールバック関数を設定、リクエストを受け取った時に実行される関数
    curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, WriteCallback);

    // コールバック関数に渡すデータ構造体の先頭アドレスを指定
    curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, (void *)&chunk);

    // 実際にHTTP GETリクエストを実行
    res = curl_easy_perform(curl_handle);

    // 通信結果をチェック
    if (res != CURLE_OK) {
        fprintf(stderr, "curl_easy_perform() 失敗: %s\n", curl_easy_strerror(res));
    } else {
        // 正常終了した場合は、レスポンスを標準出力に表示
        printf("HTTP Response:\n%s\n", chunk.memory);
    }

    // セッションを終了し、CURLハンドルのリソース解放
    curl_easy_cleanup(curl_handle);

    // グローバルなlibcurlの終了処理
    curl_global_cleanup();

    // 動的確保したレスポンスデータ領域を解放
    free(chunk.memory);

    return 0;
}