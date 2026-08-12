#!/usr/bin/env bash

############################################################
#
# SO101-OneClick-Installer
#
# scripts/07_lerobot_offline.sh
#
# Offline LeRobot Verify
#
############################################################


set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "STEP 7  Verify LeRobot Offline"



############################################################
# Environment
############################################################


CONDA_HOME="$HOME/miniforge3"

ENV_NAME="lerobot"

PYTHON="$CONDA_HOME/envs/$ENV_NAME/bin/python"

BIN="$CONDA_HOME/envs/$ENV_NAME/bin"



if [ ! -f "$PYTHON" ]

then

    error "LeRobot python environment missing"

    exit 1

fi


success "LeRobot environment found"



############################################################
# LeRobot Python Import
############################################################


echo

info "Checking LeRobot package..."



$PYTHON - <<EOF

import lerobot

print("LeRobot path:")
print(lerobot.__file__)

EOF



success "LeRobot import OK"



############################################################
# Version
############################################################


echo

info "Checking version..."


$PYTHON - <<EOF

import importlib.metadata


try:

    print(
        "LeRobot version:",
        importlib.metadata.version("lerobot")
    )

except Exception as e:

    print(e)

EOF



############################################################
# Required Python packages
############################################################


echo

info "Checking dependencies..."



check_import()
{

PKG=$1


if $PYTHON -c "import $PKG" >/dev/null 2>&1

then

    success "$PKG OK"

else

    error "$PKG missing"

    exit 1

fi

}



check_import datasets

check_import transformers

check_import accelerate

check_import scservo_sdk



############################################################
# Command Line Tools
############################################################


echo

info "Checking LeRobot commands..."



check_command()
{

CMD=$1


if [ -f "$BIN/$CMD" ]

then

    success "$CMD found"

else

    warning "$CMD missing"

fi

}



check_command lerobot-find-port

check_command lerobot-find-cameras

check_command lerobot-calibrate

check_command lerobot-record

check_command lerobot-teleoperate



############################################################
# Robot Modules
############################################################


echo

info "Checking SO101 modules..."



$PYTHON - <<EOF


from lerobot.robots.so_follower import SOFollower

print("SOFollower OK")


try:

    from lerobot.teleoperators.so_leader import SOLeader

    print("SOLeader OK")


except Exception as e:

    print("SOLeader unavailable:")
    print(e)



EOF



############################################################
# Dataset
############################################################


echo

info "Checking dataset support..."



$PYTHON - <<EOF

from lerobot.datasets import *

print("Dataset module OK")

EOF



############################################################
# Final
############################################################


echo

success "LeRobot offline environment ready"



success "STEP 7 LeRobot Offline Finished"
