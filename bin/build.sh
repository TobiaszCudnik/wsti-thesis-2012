#!/usr/bin/env sh
ROOT=dirname $0
coffee -o $ROOT/../build -cw $ROOT/../src
