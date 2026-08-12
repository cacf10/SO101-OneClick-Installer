#!/usr/bin/env bash

set -euo pipefail


############################################################
# SO101-OneClick-Installer
#
# scripts/10_verify.sh
#
# Installation verification V1.1
############################################################


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "STEP 10  Verify Installation"



############################################################
# Environment
############################################################


CONDA_DIR="$HOME/miniforge3"

ENV_NAME="lerobot"

ENV_DIR="$CONDA_DIR/envs/$ENV_NAME"

PYTHON="$ENV_DIR/bin/python"

PIP="$ENV_DIR/bin/pip"



REPORT="$HOME/so101_install_report.txt"



PASS=0
FAIL=0



############################################################
# Check helper
############################################################


check()
{

NAME="$1"

CMD="$2"


echo -n "$NAME ... "


if eval "$CMD" >/dev/null 2>&1

then

    echo "PASS"

    echo "PASS  $NAME" >> "$REPORT"

    PASS=$((PASS+1))


else

    echo "FAIL"

    echo "FAIL  $NAME" >> "$REPORT"

    FAIL=$((FAIL+1))


fi

}




############################################################
# Report
############################################################


cat > "$REPORT" <<EOF

# SO101 OneClick Installer Report

Date:
$(date)

User:
$USER

Environment:
$ENV_DIR


EOF



############################################################
# System
############################################################


echo

echo "[System]"



check \
"Ubuntu" \
"grep Ubuntu /etc/os-release"



check \
"WSL" \
"grep -qi microsoft /proc/version"



############################################################
# Conda
############################################################


echo

echo "[Conda]"



check \
"Conda Binary" \
"test -f $CONDA_DIR/bin/conda"



############################################################
# Python
############################################################


echo

echo "[Python]"



check \
"Python" \
"$PYTHON --version"



check \
"Python Import" \
"$PYTHON -c 'import sys'"



############################################################
# Torch
############################################################


echo

echo "[PyTorch]"



check \
"Torch Import" \
"$PYTHON -c 'import torch'"



check \
"Torch Version" \
"$PYTHON -c 'import torch;print(torch.__version__)'"



check \
"CUDA Available" \
"$PYTHON -c 'import torch;print(torch.cuda.is_available())'"



############################################################
# Packages
############################################################


echo

echo "[Packages]"



check \
"safetensors" \
"$PYTHON -c 'from safetensors.torch import load_file'"



check \
"tqdm" \
"$PYTHON -c 'import tqdm'"



check \
"opencv" \
"$PYTHON -c 'import cv2'"



############################################################
# LeRobot
############################################################


echo

echo "[LeRobot]"



check \
"lerobot import" \
"$PYTHON -c 'import lerobot'"



check \
"lerobot calibrate" \
"test -f $ENV_DIR/bin/lerobot-calibrate"



check \
"lerobot record" \
"test -f $ENV_DIR/bin/lerobot-record"



check \
"lerobot teleoperate" \
"test -f $ENV_DIR/bin/lerobot-teleoperate"



############################################################
# Feetech
############################################################


echo

echo "[Feetech]"



check \
"Feetech SDK" \
"$PYTHON -c 'import scservo_sdk'"



############################################################
# Robot
############################################################


echo

echo "[SO101]"



check \
"SO follower" \
"$PYTHON -c 'from lerobot.robots.so_follower import SOFollower'"



check \
"SO leader" \
"$PYTHON -c 'from lerobot.teleoperators.so_leader import SOLeader'"



############################################################
# USB
############################################################


echo

echo "[USB]"



check \
"Dialout group" \
"groups | grep dialout"



check \
"Serial device" \
"ls /dev/ttyACM*"



############################################################
# Camera
############################################################


echo

echo "[Camera]"



check \
"Video device" \
"ls /dev/video*"



check \
"OpenCV Camera" \
"$PYTHON - <<PY
import cv2

cam=cv2.VideoCapture(0)

ok=cam.isOpened()

cam.release()

exit(0 if ok else 1)

PY
"



############################################################
# Summary
############################################################


cat >> "$REPORT" <<EOF


==============================

PASS:
$PASS

FAIL:
$FAIL

EOF



echo

echo "================================"



if [ "$FAIL" -eq 0 ]

then


success "ALL TEST PASSED"


echo

echo "SO101 environment is ready."


else


warning "Some checks failed"


echo

echo "Report:"
echo "$REPORT"


fi



echo

echo "Report:"
echo "$REPORT"
