#!/bin/bash

wget -q https://raw.github.com/hoytech/vmtouch/master/vmtouch.c -O /tmp/vmtouch.c

if [[ $? == 0 ]]; then
	gcc -Wall -O3 -o /usr/local/sbin/vmtouch /tmp/vmtouch.c
fi

rm -rf /tmp/vmtouch.c
