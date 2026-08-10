#!/usr/bin/env bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")"; pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"
source "$ROOT_DIR/libs/check.sh"
source "$ROOT_DIR/libs/utils.sh"

echo_blue "====================================="
echo_blue " SO101 One Click Installer V1.0"
echo_blue "====================================="

check_system

source scripts/03_conda.sh

source scripts/04_environment.sh

source scripts/06_torch.sh

source scripts/07_lerobot.sh

source scripts/08_usb.sh

echo_green ""
echo_green "Installation Finished!"
