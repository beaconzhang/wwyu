#!/usr/bin/env bash

cd $(dirname $0);
 ../../../openresty/install/luajit/bin/luajit t_util.lua
