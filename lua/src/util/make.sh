#!/usr/bin/env bash
#export C_INCLUDE_PATH=/home/yuzhengtian/project/openresty/install/luajit/include/luajit-2.1/:$C_INCLUDE_PATH
#export LIBRARY_PATH=/home/yuzhengtian/project/openresty/install/luajit/lib:$LIBRARY_PATH
#LIB="-lluajit-5.1"
gcc *.c -o test.exe

gcc -shared -fpic -O  util.c -o ../../lib/libutil.so 
