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

bash scripts/03_conda.sh

bash scripts/04_environment.sh

bash scripts/06_torch.sh

bash scripts/07_lerobot.sh

bash scripts/08_usb.sh

echo_green ""
echo_green "Installation Finished!"
