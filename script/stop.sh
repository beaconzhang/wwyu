#/usr/bin/env bash

ps -ef |grep nginx|grep -v grep |awk '{print $2}' |xargs kill -9
