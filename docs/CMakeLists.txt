# srcディレクトリ配下のC言語プログラムをまとめてコンパイルする設定
cmake_minimum_required(VERSION 3.28)
project(MyRepository C)

set(CMAKE_C_STANDARD 11)

# OpenSSLの検出
find_package(OpenSSL REQUIRED)

# ディレクトリのインクルード
include_directories(/usr/include)
include_directories(/usr/local/include)
include_directories(third_party)

# ソース一覧
file(GLOB SRC_C_FILES "src/*.c")

foreach(SRC_FILE ${SRC_C_FILES})
    get_filename_component(FILENAME ${SRC_FILE} NAME_WE)
    add_executable(${FILENAME} ${SRC_FILE})

    # math.h用
    target_link_libraries(${FILENAME} m)

    # OpenSSLを使うプログラム
    if(${FILENAME} STREQUAL "getHTML_openssl")
        target_link_libraries(${FILENAME} OpenSSL::SSL OpenSSL::Crypto)
    endif()

    # wolfSSLを使うプログラム
    if(${FILENAME} STREQUAL "getHTML_wolfssl")
        target_link_libraries(${FILENAME} wolfssl)
    endif()
endforeach()
