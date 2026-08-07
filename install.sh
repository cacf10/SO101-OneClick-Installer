#!/usr/bin/env bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")"; pwd)"

source "$ROOT_DIR/lib/colors.sh"
source "$ROOT_DIR/lib/logger.sh"
source "$ROOT_DIR/lib/check.sh"
source "$ROOT_DIR/lib/utils.sh"

echo_blue "====================================="
echo_blue " SO101 One Click Installer V1.0"
echo_blue "====================================="

check_system

bash scripts/install_conda.sh

bash scripts/create_env.sh

bash scripts/install_torch.sh

bash scripts/install_lerobot.sh

bash scripts/setup_usb.sh

echo_green ""
echo_green "Installation Finished!"
