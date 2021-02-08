
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _NGX_SOCKET_H_INCLUDED_
#define _NGX_SOCKET_H_INCLUDED_


#include <ngx_config.h>


#define NGX_WRITE_SHUTDOWN SHUT_WR

typedef int  ngx_socket_t;

#if (NGX_USE_NTS)
// for nts
#define nts_ngx_socket          nts_socket
#define nts_ngx_socket_n        "nts_socket()"
#endif

#define ngx_socket          socket
#define ngx_socket_n        "socket()"



#if (NGX_HAVE_FIONBIO)

int ngx_nonblocking(ngx_socket_t s);
int ngx_blocking(ngx_socket_t s);

#define ngx_nonblocking_n   "ioctl(FIONBIO)"
#define ngx_blocking_n      "ioctl(!FIONBIO)"

#if (NGX_USE_NTS)
// for nts
#define nts_ngx_nonblocking_n   "nts_ioctl(FIONBIO)"
#define nts_ngx_blocking_n      "nts_ioctl(!FIONBIO)"
#endif

#else

#if (NGX_USE_NTS)
// for nts
#define nts_ngx_nonblocking(s)  nts_fcntl(s, F_SETFL, nts_fcntl(s, F_GETFL) | O_NONBLOCK)
#define nts_ngx_nonblocking_n   "nts_fcntl(O_NONBLOCK)"
#endif
#define ngx_nonblocking(s)  fcntl(s, F_SETFL, fcntl(s, F_GETFL) | O_NONBLOCK)
#define ngx_nonblocking_n   "fcntl(O_NONBLOCK)"

#if (NGX_USE_NTS)
// for nts
#define nts_ngx_blocking(s)     nts_fcntl(s, F_SETFL, nts_fcntl(s, F_GETFL) & ~O_NONBLOCK)
#define nts_ngx_blocking_n      "nts_fcntl(!O_NONBLOCK)"
#endif

#define ngx_blocking(s)     fcntl(s, F_SETFL, fcntl(s, F_GETFL) & ~O_NONBLOCK)
#define ngx_blocking_n      "fcntl(!O_NONBLOCK)"

#endif

int ngx_tcp_nopush(ngx_socket_t s);
int ngx_tcp_push(ngx_socket_t s);

#if (NGX_LINUX)

#define ngx_tcp_nopush_n   "setsockopt(TCP_CORK)"
#define ngx_tcp_push_n     "setsockopt(!TCP_CORK)"

#else

#define ngx_tcp_nopush_n   "setsockopt(TCP_NOPUSH)"
#define ngx_tcp_push_n     "setsockopt(!TCP_NOPUSH)"

#endif

#if (NGX_USE_NTS)
// for nts
#define nts_ngx_shutdown_socket     nts_shutdown
#define nts_ngx_shutdown_socket_n  "nts_shutdown()"
#endif
#define ngx_shutdown_socket    shutdown
#define ngx_shutdown_socket_n  "shutdown()"

#if (NGX_USE_NTS)
// for nts
#define nts_ngx_close_socket    nts_close
#define nts_ngx_close_socket_n  "close() socket"
#endif
#define ngx_close_socket    close
#define ngx_close_socket_n  "close() socket"


#endif /* _NGX_SOCKET_H_INCLUDED_ */
