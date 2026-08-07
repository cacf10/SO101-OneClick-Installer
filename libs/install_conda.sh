#!/usr/bin/env bash

source config.conf

echo_green "Installing Miniforge..."

if command -v conda >/dev/null

then

echo_green "Conda already installed."

exit 0

fi

wget ...

bash Miniforge.sh -b

source ~/miniforge3/bin/activate

conda init
