/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define to 1 if arpa/inet.h declares `ether_ntohost' */
/* #undef ARPA_INET_H_DECLARES_ETHER_NTOHOST */

/* define if you want to build the possibly-buggy SMB printer */
/* #undef ENABLE_SMB */

/* Define to 1 if you have the `bpf_dump' function. */
#define HAVE_BPF_DUMP 1

/* capsicum support available */
/* #undef HAVE_CAPSICUM */

/* Define to 1 if you have the `cap_enter' function. */
/* #undef HAVE_CAP_ENTER */

/* Define to 1 if you have the `cap_ioctls_limit' function. */
/* #undef HAVE_CAP_IOCTLS_LIMIT */

/* Define to 1 if you have the <cap-ng.h> header file. */
/* #undef HAVE_CAP_NG_H */

/* Define to 1 if you have the `cap_rights_limit' function. */
/* #undef HAVE_CAP_RIGHTS_LIMIT */

/* Casper support available */
/* #undef HAVE_CASPER */

/* Define to 1 if you have the declaration of `ether_ntohost' */
/* #undef HAVE_DECL_ETHER_NTOHOST */

/* Define to 1 if you have the `ether_ntohost' function. */
#define HAVE_ETHER_NTOHOST 1

/* Define to 1 if you have the `EVP_CIPHER_CTX_new' function. */
/* #undef HAVE_EVP_CIPHER_CTX_NEW */

/* Define to 1 if you have the `EVP_DecryptInit_ex' function. */
/* #undef HAVE_EVP_DECRYPTINIT_EX */

/* Define to 1 if you have the <fcntl.h> header file. */
#define HAVE_FCNTL_H 1

/* Define to 1 if you have the `fork' function. */
#define HAVE_FORK 1

/* Define to 1 if you have the `getopt_long' function. */
#define HAVE_GETOPT_LONG 1

/* define if you have getrpcbynumber() */
#define HAVE_GETRPCBYNUMBER 1

/* Define to 1 if you have the `getservent' function. */
#define HAVE_GETSERVENT 1

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define to 1 if you have the `cap-ng' library (-lcap-ng). */
/* #undef HAVE_LIBCAP_NG */

/* Define to 1 if you have the `crypto' library (-lcrypto). */
/* #undef HAVE_LIBCRYPTO */

/* Define to 1 if you have the `rpc' library (-lrpc). */
/* #undef HAVE_LIBRPC */

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the <net/if.h> header file. */
#define HAVE_NET_IF_H 1

/* Define to 1 if printf(3) does not support the z length modifier. */
/* #undef HAVE_NO_PRINTF_Z */

/* Define to 1 if you have the `openat' function. */
/* #undef HAVE_OPENAT */

/* Define to 1 if you have the <openssl/evp.h> header file. */
/* #undef HAVE_OPENSSL_EVP_H */

/* define if the OS provides AF_INET6 and struct in6_addr */
#define HAVE_OS_IPV6_SUPPORT 1

/* if there's an os_proto.h for this platform, to use additional prototypes */
/* #undef HAVE_OS_PROTO_H */

/* Define to 1 if you have the `pcap_breakloop' function. */
#define HAVE_PCAP_BREAKLOOP 1

/* Define to 1 if you have the `pcap_create' function. */
#define HAVE_PCAP_CREATE 1

/* define if libpcap has pcap_datalink_name_to_val() */
#define HAVE_PCAP_DATALINK_NAME_TO_VAL 1

/* define if libpcap has pcap_datalink_val_to_description() */
#define HAVE_PCAP_DATALINK_VAL_TO_DESCRIPTION 1

/* define if libpcap has pcap_debug */
/* #undef HAVE_PCAP_DEBUG */

/* Define to 1 if you have the `pcap_dump_flush' function. */
#define HAVE_PCAP_DUMP_FLUSH 1

/* Define to 1 if you have the `pcap_dump_ftell' function. */
#define HAVE_PCAP_DUMP_FTELL 1

/* Define to 1 if you have the `pcap_dump_ftell64' function. */
#define HAVE_PCAP_DUMP_FTELL64 1

/* Define to 1 if you have the `pcap_findalldevs' function. */
#define HAVE_PCAP_FINDALLDEVS 1

/* Define to 1 if you have the `pcap_findalldevs_ex' function. */
/* #undef HAVE_PCAP_FINDALLDEVS_EX */

/* Define to 1 if you have the `pcap_free_datalinks' function. */
#define HAVE_PCAP_FREE_DATALINKS 1

/* Define to 1 if the system has the type `pcap_if_t'. */
#define HAVE_PCAP_IF_T 1

/* Define to 1 if you have the `pcap_lib_version' function. */
#define HAVE_PCAP_LIB_VERSION 1

/* define if libpcap has pcap_list_datalinks() */
#define HAVE_PCAP_LIST_DATALINKS 1

/* Define to 1 if you have the `pcap_open' function. */
/* #undef HAVE_PCAP_OPEN */

/* Define to 1 if you have the <pcap/pcap-inttypes.h> header file. */
#define HAVE_PCAP_PCAP_INTTYPES_H 1

/* Define to 1 if you have the `pcap_setdirection' function. */
#define HAVE_PCAP_SETDIRECTION 1

/* Define to 1 if you have the `pcap_set_datalink' function. */
#define HAVE_PCAP_SET_DATALINK 1

/* Define to 1 if you have the `pcap_set_immediate_mode' function. */
#define HAVE_PCAP_SET_IMMEDIATE_MODE 1

/* Define to 1 if you have the `pcap_set_optimizer_debug' function. */
/* #undef HAVE_PCAP_SET_OPTIMIZER_DEBUG */

/* Define to 1 if you have the `pcap_set_parser_debug' function. */
/* #undef HAVE_PCAP_SET_PARSER_DEBUG */

/* Define to 1 if you have the `pcap_set_tstamp_precision' function. */
#define HAVE_PCAP_SET_TSTAMP_PRECISION 1

/* Define to 1 if you have the `pcap_set_tstamp_type' function. */
#define HAVE_PCAP_SET_TSTAMP_TYPE 1

/* define if libpcap has pcap_version */
/* #undef HAVE_PCAP_VERSION */

/* Define to 1 if you have the `pfopen' function. */
/* #undef HAVE_PFOPEN */

/* Define to 1 if you have the <rpc/rpcent.h> header file. */
/* #undef HAVE_RPC_RPCENT_H */

/* Define to 1 if you have the <rpc/rpc.h> header file. */
/* #undef HAVE_RPC_RPC_H */

/* Define to 1 if you have the `setlinebuf' function. */
#define HAVE_SETLINEBUF 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the `strdup' function. */
#define HAVE_STRDUP 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the `strlcat' function. */
#define HAVE_STRLCAT 1

/* Define to 1 if you have the `strlcpy' function. */
#define HAVE_STRLCPY 1

/* Define to 1 if you have the `strsep' function. */
#define HAVE_STRSEP 1

/* Define to 1 if the system has the type `struct ether_addr'. */
/* #undef HAVE_STRUCT_ETHER_ADDR */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if the system has the type `uintptr_t'. */
#define HAVE_UINTPTR_T 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the `vfork' function. */
#define HAVE_VFORK 1

/* define if libpcap has yydebug */
/* #undef HAVE_YYDEBUG */

/* Define to 1 if netinet/ether.h declares `ether_ntohost' */
/* #undef NETINET_ETHER_H_DECLARES_ETHER_NTOHOST */

/* Define to 1 if netinet/if_ether.h declares `ether_ntohost' */
/* #undef NETINET_IF_ETHER_H_DECLARES_ETHER_NTOHOST */

/* Define to 1 if net/ethernet.h declares `ether_ntohost' */
/* #undef NET_ETHERNET_H_DECLARES_ETHER_NTOHOST */

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT ""

/* Define to the full name of this package. */
#define PACKAGE_NAME "tcpdump"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "tcpdump 4.99.4"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "tcpdump"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "4.99.4"

/* The size of `void *', as computed by sizeof. */
/* #undef SIZEOF_VOID_P */

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define to 1 if sys/ethernet.h declares `ether_ntohost' */
/* #undef SYS_ETHERNET_H_DECLARES_ETHER_NTOHOST */

/* define if you have ether_ntohost() and it works */
/* #undef USE_ETHER_NTOHOST */

/* Define if you enable support for libsmi */
/* #undef USE_LIBSMI */

/* define if should chroot when dropping privileges */
/* #undef WITH_CHROOT */

/* define if should drop privileges by default */
/* #undef WITH_USER */

/* define on AIX to get certain functions */
/* #undef _SUN */

/* to handle Ultrix compilers that don't support const in prototypes */
/* #undef const */

/* Define as token for inline if inlining supported */
#define inline inline

/* Define to `uint16_t' if u_int16_t not defined. */
/* #undef u_int16_t */

/* Define to `uint32_t' if u_int32_t not defined. */
/* #undef u_int32_t */

/* Define to `uint64_t' if u_int64_t not defined. */
/* #undef u_int64_t */

/* Define to `uint8_t' if u_int8_t not defined. */
/* #undef u_int8_t */

/* Define to the type of an unsigned integer type wide enough to hold a
   pointer, if such a type exists, and if the system does not define it. */
/* #undef uintptr_t */
