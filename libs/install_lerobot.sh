#!/usr/bin/env bash

source config.conf

cd ~

if [ ! -d lerobot ]; then
    git clone https://github.com/huggingface/lerobot.git
fi

cd lerobot

git checkout v${LEROBOT_VERSION}

pip install -e ".[feetech]"
