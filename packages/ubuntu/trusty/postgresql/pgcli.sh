#!/usr/bin/env bash

apt-get -qq install python-dev python-pip > /dev/null && pip -q install -U setuptools pip > /dev/null && pip -q install pgcli > /dev/null 2>&1
