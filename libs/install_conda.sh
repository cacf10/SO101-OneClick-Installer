#!/usr/bin/env bash

source config.conf

echo "Installing Conda packages..."

conda install -y \
    --file packages/conda.txt
