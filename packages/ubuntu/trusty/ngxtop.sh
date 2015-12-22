#!/usr/bin/env bash

if [[ ! $(type -P pip) ]]; then
    apt-get -qq install python-pip > /dev/null
fi

pip -q install ngxtop > /dev/null
