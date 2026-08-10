#!/usr/bin/env bash

set -euo pipefail

############################################################
# SO101 OneClick Installer
# Version: 1.0.0
############################################################

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

############################################################
# Load libraries
############################################################

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"
source "$ROOT_DIR/libs/check.sh"
source "$ROOT_DIR/libs/utils.sh"

############################################################
# Banner
############################################################

echo_blue "====================================="
echo_blue " SO101 One Click Installer V1.0.0"
echo_blue "====================================="

echo_blue "Installer directory:"
echo_blue "$ROOT_DIR"

############################################################
# System check
############################################################

check_system

############################################################
# Installation modules
############################################################

source "$ROOT_DIR/scripts/00_precheck.sh"

source "$ROOT_DIR/scripts/01_system.sh"

source "$ROOT_DIR/scripts/02_mirror.sh"

source "$ROOT_DIR/scripts/03_conda.sh"

source "$ROOT_DIR/scripts/04_environment.sh"

source "$ROOT_DIR/scripts/05_python.sh"

source "$ROOT_DIR/scripts/06_torch.sh"

source "$ROOT_DIR/scripts/07_lerobot.sh"

source "$ROOT_DIR/scripts/08_usb.sh"

source "$ROOT_DIR/scripts/09_camera.sh"

source "$ROOT_DIR/scripts/10_verify.sh"

source "$ROOT_DIR/scripts/11_finish.sh"

############################################################
# Finished
############################################################

echo_green ""
echo_green "====================================="
echo_green " Installation Finished!"
echo_green "====================================="
