#!/usr/bin/env bash
_PWD=$(cd $(dirname $0);pwd)

/usr/local/openresty/nginx/sbin/nginx -c $_PWD/../conf/nginx.conf
