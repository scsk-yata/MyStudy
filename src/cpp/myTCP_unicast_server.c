/* TCP通信のサーバ側のプログラム */
#include <stdio.h>      // 標準入出力関数 (printf, perror など)
#include <stdlib.h>     // メモリ管理関数および exit() の使用
#include <string.h>     // 文字列操作関数 (memset, strlen など)
#include <unistd.h>     // UNIXシステムコール (close, read, write など)
#include <arpa/inet.h>  // ネットワーク関連関数 (socket, bind, listen, accept など)
#include <fcntl.h>      // ノンブロッキングソケットの設定用 (fcntl)
#include <sys/select.h> // select() を用いた複数ソケットの監視用

/*マクロの定義*/
#define SERVER_PORT 8080   // サーバーが待ち受けるポート番号
#define MAX_QUEUE 5         // listen() に渡す接続待ち行列の最大数
#define BUFFER_SIZE 1024    // 受信バッファサイズ
#define MAX_CLIENTS 10      // 同時接続可能な最大クライアント数

int main() {
    int server_sock, client_sock;  // サーバーソケットとクライアントソケットのファイルディスクリプタ
    struct sockaddr_in server_addr, client_addr; // サーバーおよびクライアントのアドレス情報を格納する構造体
    socklen_t addr_len = sizeof(server_addr); // アドレス構造体のサイズ
    char buffer[BUFFER_SIZE];    // 受信データのバッファ

    fd_set read_fds;  // select() で読み取り操作を監視するファイルディスクリプタの集合
    int max_fd;       // 監視する最大ファイルディスクリプタ数

    /*ソケットの作成 (IPv4, TCP通信)*/
    server_sock = socket(AF_INET, SOCK_STREAM, 0); // IPv4 (AF_INET), TCP (SOCK_STREAM) を指定
    if (server_sock < 0) {
        perror("Socket creation failed"); // ソケット作成に失敗した場合のエラーメッセージ
        exit(EXIT_FAILURE); // プログラムを異常終了
    }

    /*ソケットのオプション設定により、ローカルアドレスの再利用を許可*/
    int opt = 1; // オプションの値を 1 に設定、SOL_SOCKET(ソケットレベルのオプションを設定する)
    setsockopt(server_sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)); /* SO_REUSEADDR を有効化
    // サーバーが終了した直後でも、同じポート番号を使用して再起動可能になる */

    /*サーバーアドレス構造体の設定*/
    memset(&server_addr, 0, sizeof(server_addr)); // 構造体のメモリをゼロクリア
    server_addr.sin_family = AF_INET;             // IPv4 を使用
    server_addr.sin_addr.s_addr = INADDR_ANY;     // 全ての利用可能なIPアドレスで待ち受ける設定にする
    server_addr.sin_port = htons(SERVER_PORT);    // ポート番号をネットワークバイトオーダー（ビッグエンディアン）へ変換

    /*ソケットにアドレスをバインド*/
    if (bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed"); // バインド失敗時のエラーメッセージ
        exit(EXIT_FAILURE);
    }

    /* クライアントからの接続要求を待機開始 */
    if (listen(server_sock, MAX_QUEUE) < 0) {
        perror("Listen failed"); // リスニング失敗時のエラーメッセージ
        exit(EXIT_FAILURE);
    }

    /*ノンブロッキングモードに設定
    ソケット操作がブロックせずに実行され、データが存在しない場合でも操作が即座に戻り、プログラムが停止しない */
    fcntl(server_sock, F_SETFL, O_NONBLOCK); // サーバーソケットをノンブロッキングモードに変更
    /* F_SETFL: ファイルステータスフラグを設定するコマンド。*/
    printf("Server listening on port %d...\n", SERVER_PORT); // サーバーの起動メッセージ

    /*クライアント管理用配列を初期化*/
    int client_sockets[MAX_CLIENTS]; // クライアントソケットの接続状態管理用配列
    for (int i = 0; i < MAX_CLIENTS; i++) {
        client_sockets[i] = -1;  // 未使用スロットを -1 に設定（初期状態）
    }

    do {
        FD_ZERO(&read_fds);  // 監視対象のファイルディスクリプタ(fd)集合をクリア
        FD_SET(server_sock, &read_fds);  // サーバーソケットを監視対象に追加
        max_fd = server_sock;  // 初期の最大fdをサーバーソケットに設定

        /*既存のクライアントソケットを監視対象に追加*/
        for (int i = 0; i < MAX_CLIENTS; i++) {
            int sock = client_sockets[i];
            if (sock > 0) {
                FD_SET(sock, &read_fds);  // クライアントソケットを順番に監視リストに追加
            }
            if (sock > max_fd) {
                max_fd = sock;  // 最大fdを更新
            }
        }

        /*ソケットの状態を監視 (ブロックせずに処理)*/
        int activity = select(max_fd + 1, &read_fds, NULL, NULL, NULL); // 書込可能状態、例外状態の監視、TO時間はなし
                if (activity < 0) {
            perror("Select error"); // select() のエラー処理
            exit(EXIT_FAILURE);
        }

        /*サーバー側の新規クライアント接続の処理*/
        if (FD_ISSET(server_sock, &read_fds)) { // server_sockが読み取り可能（新規接続要求がある）状態かを確認
            client_sock = accept(server_sock, (struct sockaddr *)&client_addr, &addr_len);
            if (client_sock < 0) { // 新規クライアントの接続受け入れ時に正の整数の識別番号が割り振られるはず
                perror("Accept failed");
                continue;
            }

            printf("New connection: socket %d, IP %s, port %d\n",
                   client_sock,
                   inet_ntoa(client_addr.sin_addr), // クライアントのIPアドレスを文字列に変換
                   ntohs(client_addr.sin_port)); // ポート番号をホストバイトオーダー（エンディアン）へ変換

            // 空いているソケット番号にクライアントを登録
            for (int i = 0; i < MAX_CLIENTS; i++) {
                if (client_sockets[i] == -1) {
                    client_sockets[i] = client_sock;
                    break;
                }
            }
        }
    } while (1);

    return 0;
}