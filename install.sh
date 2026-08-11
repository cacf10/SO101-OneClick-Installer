#!/usr/bin/env bash

set -euo pipefail


############################################################
# SO101 OneClick Installer
# Version: 1.1.0
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
# Mode
############################################################


MODE="online"


if [[ "${1:-}" == "--offline" ]]; then

    MODE="offline"

fi



############################################################
# Banner
############################################################


echo_blue "====================================="
echo_blue " SO101 One Click Installer V1.1.0"
echo_blue "====================================="

echo_blue ""
echo_blue "Installer directory:"
echo_blue "$ROOT_DIR"

echo_blue ""

echo_yellow "Install Mode: $MODE"



############################################################
# System check
############################################################


check_system



############################################################
# Precheck
############################################################


bash "$ROOT_DIR/scripts/00_precheck.sh"


############################################################
# System
############################################################


bash "$ROOT_DIR/scripts/01_system.sh"


############################################################
# Mirror
############################################################


if [ "$MODE" = "online" ]; then

    bash "$ROOT_DIR/scripts/02_mirror.sh"

else

    echo_yellow "Offline mode: skip mirrors"

fi



############################################################
# Conda
############################################################

############################################################
# Environment
############################################################


if [ "${1:-}" = "--offline" ]

then

    bash "$ROOT_DIR/scripts/03_conda_offline.sh"

    bash "$ROOT_DIR/scripts/04_environment_offline.sh"

else

    bash "$ROOT_DIR/scripts/03_conda.sh"

    bash "$ROOT_DIR/scripts/04_environment.sh"

fi


    bash "$ROOT_DIR/scripts/05_python.sh"


    bash "$ROOT_DIR/scripts/06_torch.sh"


    bash "$ROOT_DIR/scripts/07_lerobot.sh"






############################################################
# Hardware
############################################################


bash "$ROOT_DIR/scripts/08_usb.sh"


bash "$ROOT_DIR/scripts/09_camera.sh"



############################################################
# Verify
############################################################


bash "$ROOT_DIR/scripts/10_verify.sh"



############################################################
# Finish
############################################################


bash "$ROOT_DIR/scripts/11_finish.sh"



############################################################
# Finished
############################################################


echo_green ""

echo_green "====================================="
echo_green " Installation Finished!"
echo_green "====================================="

echo_green ""

echo_green "Mode:"
echo_green "$MODE"
