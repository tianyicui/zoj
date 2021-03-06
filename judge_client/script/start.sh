#!/bin/bash

JUDGE_USER=65533
JUDGE_GROUP=65533
UNTRUSTED_USER=65534
UNTRUSTED_GROUP=65534


set -e

function CreateDir() {
    if [ -e "$1" ]; then
        if ! [ -d "$1" ]; then
            echo "$1" exists but is not a directory
            exit 1
        fi
    else
        mkdir "$1"
    fi
    chmod $2 "$1"
    chown zoj:zoj "$1"
}

if [ "$1" == "" ]; then
    echo "Usage: start.sh <server address>:<server port>"
    exit 1
fi

address=${1%:*}
port=${1##*:}

root=`readlink /proc/$$/fd/255`
root=${root%/*}

if [ "`which unzip`" == "" ]; then
    echo "No unzip found!"
    exit 1
fi

if [ "`which gcc`" != "" ]; then
    supported_source_file_types=$supported_source_file_types,gcc
fi

if [ "`which g++`" != "" ]; then
    supported_source_file_types=$supported_source_file_types,g++
fi

if [ "`which fpc`" != "" ]; then
    supported_source_file_types=$supported_source_file_types,fpc
fi

if [[ "`which java`" != "" && "`which javac`" != "" ]]; then
    supported_source_file_types=$supported_source_file_types,javac
fi

if [[ "`which python`" != "" && "`which pyflakes`" != "" ]]; then
    supported_source_file_types=$supported_source_file_types,python
fi

if [ "`which perl`" != "" ]; then
    supported_source_file_types=$supported_source_file_types,perl
fi

if [ "`which guile`" != "" ]; then
    supported_source_file_types=$supported_source_file_types,scheme
fi

if [ "`which php`" != "" ]; then
    supported_source_file_types=$supported_source_file_types,php
fi

if [[ "`which bf2c`" != "" && "`which gcc`" != "" ]]; then
    supported_source_file_types=$supported_source_file_types,brainfuck
fi

# Prepare /prob
CreateDir "$root/prob" 750
CreateDir "$root/prob/0" 750
CreateDir "$root/prob/0/0" 750
if [ ! -f "$root/prob/0/0/1.in" ]; then
    echo -e "0 0\n1 2\n2 3" > "$root/prob/0/0/1.in"
fi
if [ ! -f "$root/prob/0/0/1.out" ]; then
    echo -e "0\n3\n5" > "$root/prob/0/0/1.out"
fi
chmod -R 750 "$root"/prob/0/*

# Prepare /working
CreateDir "$root/working" 750
rm -rf "$root"/working/*

# Prepare /log
CreateDir "$root/log" 750

cmd="sudo -u \\#$JUDGE_USER $root/judged --compiler='$supported_source_file_types' --daemonize=true --root='$root' --queue_address='$address' --queue_port=$port --uid=$UNTRUSTED_USER --gid=$UNTRUSTED_GROUP"
echo $cmd
eval $cmd
