# 最小要件バージョン
cmake_minimum_required(VERSION 3.22)

# プロジェクト名とプログラミング言語
project(MyRepository C CXX)

# C標準/C++標準の設定
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# wolfSSLは手動リンク（必要に応じてパスを明示）
set(WOLFSSL_LIBRARIES wolfssl)
set(WOLFSSL_USER_SETTINGS yes)
set(BUILD_SHARED_LIBS no)
set(WOLFSSL_LINUX_KM yes)

set(WOLFSSL_EXAMPLES no)
set(WOLFSSL_CRYPT_TESTS no)

# OpenSSLはパッケージとして探させる
find_package(OpenSSL REQUIRED)

# 一部ファイルのリンク設定（OpenSSL, wolfSSL）
set(WITH_WOLFSSL src/getHTML_wolfssl.c)
set(WITH_OPENSSL src/getHTML_openssl.c)

# C/C++の拡張子でソースを一括取得
#file(GLOB SRC_FILES "src/*.c")
#foreach(src ${SRC_FILES})
#    get_filename_component(target ${src} NAME_WE)
#    add_executable(${target} ${src})
#endforeach()

add_executable(FizzBuzzcpp src/FizzBuzz.cpp)
add_executable(getHTML_notssl src/getHTML_notssl.c)
add_executable(myList1_1 src/myList1_1.c)
add_executable(myList1_2 src/myList1_2.c)
target_link_libraries(myList1_2 m)
add_executable(myList1_3 src/myList1_3.c)
add_executable(myList1_7 src/myList1_7.c)
add_executable(myList1_8 src/myList1_8.c)
add_executable(myList1_17 src/myList1_17.c)
add_executable(myList4_1 src/myList4_1.c)
target_link_libraries(myList4_1 m)
add_executable(myList4_3 src/myList4_3.c)
target_link_libraries(myList4_3 m)
add_executable(myList4_4 src/myList4_4.c)
target_link_libraries(myList4_4 m)
add_executable(myList4_5 src/myList4_5.c)
target_link_libraries(myList4_5 m)
add_executable(myList4_6 src/myList4_6.c)
target_link_libraries(myList4_6 m)
add_executable(myList5_1 src/myList5_1.c)
target_link_libraries(myList5_1 m)
add_executable(myList5_4 src/myList5_4.c)
target_link_libraries(myList5_4 m)
add_executable(myList6_1_Appendix2 src/myList6_1_Appendix2.c)
target_link_libraries(myList6_1_Appendix2 m)
add_executable(myList6_1_Appendix3 src/myList6_1_Appendix3.c)
target_link_libraries(myList6_1_Appendix3 m)
add_executable(myList6_1 src/myList6_1.c)
target_link_libraries(myList6_1 m)
add_executable(myList7_1 src/myList7_1.c)
target_link_libraries(myList7_1 m)

#include_directories(wolfssl)
#include_directories(src)
#add_subdirectory(wolfssl)
#add_executable(getHTML_wolfssl src/getHTML_wolfssl.c)
#target_link_libraries(getHTML_wolfssl wolfssl)

#file(GLOB SRC_CPP_FILES "src/*.cpp")

# すべてのC/C++ファイルに対してビルド設定
#foreach(SRC_FILE ${SRC_C_FILES} ${SRC_CPP_FILES})
#  get_filename_component(FILENAME ${SRC_FILE} NAME_WE)

#  add_executable(${FILENAME} ${SRC_FILE})

#  if(SRC_FILE STREQUAL ${WITH_OPENSSL})
#    target_link_libraries(${FILENAME} OpenSSL::SSL OpenSSL::Crypto)
#  elseif(SRC_FILE STREQUAL ${WITH_WOLFSSL})
#    target_link_libraries(${FILENAME} ${WOLFSSL_LIBRARIES})
#  endif()
#endforeach()

# include_directories や link_directories が必要なら以下を追加
# include_directories(/usr/local/include)
# link_directories(/usr/local/lib)