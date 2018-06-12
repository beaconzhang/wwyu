#!/usr/bin/env bash

cd $(dirname $0)

python m_crawler.py 2>&1 >>log.txt &
