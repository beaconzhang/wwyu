#!/usr/bin/env bash
_PWD=$(cd $(dirname $0);pwd)
NGINX_POS=/home/yuzhengtian/project/
$NGINX_POS/openresty/install/nginx/sbin/nginx -c $_PWD/../conf/nginx.conf -s reload
