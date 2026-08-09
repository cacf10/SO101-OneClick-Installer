#!/usr/bin/env bash
#
# SO101-OneClick-Installer
#
# scripts/10_verify.sh
#
# Installation verification
#

set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "STEP 10  Verify Installation"

source "$ROOT_DIR/libs/conda.sh"

load_conda

conda activate lerobot

REPORT="$HOME/so101_install_report.txt"



PASS=0
FAIL=0



####################################
# helper
####################################


check()
{
    NAME=$1
    CMD=$2


    echo -n "$NAME ... "


    if eval "$CMD" >/dev/null 2>&1
    then

        echo "PASS"

        echo "PASS  $NAME" >> $REPORT

        PASS=$((PASS+1))


    else

        echo "FAIL"

        echo "FAIL  $NAME" >> $REPORT

        FAIL=$((FAIL+1))

    fi

}



####################################
# report header
####################################


cat > $REPORT <<EOF

SO101 OneClick Installer Report
================================

Date:

$(date)


User:

$USER


EOF



####################################
# system
####################################


echo

echo "[System]"



check \
"Ubuntu" \
"grep Ubuntu /etc/os-release"



check \
"WSL" \
"grep -qi microsoft /proc/version"



####################################
# Conda
####################################


echo

echo "[Conda]"



check \
"Conda" \
"command -v conda"



####################################
# Python
####################################


echo

echo "[Python]"



check \
"Python3" \
"python --version"



check \
"Python Import" \
"python -c 'import sys'"



####################################
# Torch
####################################


echo

echo "[PyTorch]"



check \
"Torch" \
"python -c 'import torch'"



check \
"Torch Version" \
"python -c 'import torch;print(torch.__version__)'"



check \
"CUDA Query" \
"python -c 'import torch;print(torch.cuda.is_available())'"



####################################
# Python packages
####################################


echo

echo "[Packages]"



check \
"safetensors" \
"python -c 'from safetensors.torch import load_file'"



check \
"tqdm" \
"python -c 'import tqdm'"



check \
"opencv" \
"python -c 'import cv2'"



####################################
# LeRobot
####################################


echo

echo "[LeRobot]"



check \
"lerobot import" \
"python -c 'import lerobot'"



check \
"lerobot cli" \
"command -v lerobot-find-port"



check \
"lerobot calibrate" \
"command -v lerobot-calibrate"



check \
"lerobot teleoperate" \
"command -v lerobot-teleoperate"




####################################
# Feetech
####################################


echo

echo "[Feetech]"



check \
"Feetech SDK" \
"python -c 'import feetech_servo_sdk'"




####################################
# Robot
####################################


echo

echo "[SO101]"



check \
"SO follower" \
"python -c 'from lerobot.robots.so_follower import SOFollower'"



check \
"SO leader" \
"python -c 'from lerobot.teleoperators.so_leader import SOLeader'"



####################################
# USB
####################################


echo

echo "[USB]"



check \
"Dialout group" \
"groups | grep dialout"



check \
"Serial device" \
"ls /dev/ttyACM*"



####################################
# Camera
####################################


echo

echo "[Camera]"



check \
"Video device" \
"ls /dev/video*"



check \
"OpenCV camera" \
"python - <<PY
import cv2
c=cv2.VideoCapture(0)
r=c.isOpened()
c.release()
exit(0 if r else 1)
PY
"



####################################
# Summary
####################################


cat >> $REPORT <<EOF


==============================

PASS:

$PASS


FAIL:

$FAIL


EOF



echo

echo "================================"


if [ $FAIL -eq 0 ]
then

    success "ALL TEST PASSED"

    echo

    echo "SO101 environment is ready."

else

    warning "Some checks failed"

    echo

    echo "Please check report:"
    echo "$REPORT"

fi



echo

echo "Report:"
echo "$REPORT"
