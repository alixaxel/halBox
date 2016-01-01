#!/usr/bin/env bash

wget -q https://static.rust-lang.org/rustup.sh -O /tmp/rustup.sh

if [[ $? == 0 ]]; then
    chmod +x /tmp/rustup.sh && /tmp/rustup.sh -y > /dev/null 2>&1
fi

rm -rf /tmp/rustup.sh
