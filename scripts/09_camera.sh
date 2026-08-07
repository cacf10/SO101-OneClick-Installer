#!/usr/bin/env bash
#
# SO101-OneClick-Installer
#
# scripts/09_camera.sh
#
# Camera setup for LeRobot
#

set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/lib/colors.sh"
source "$ROOT_DIR/lib/logger.sh"



title "STEP 9  Configure Camera"



########################################
# Install packages
########################################


info "Installing camera packages"


sudo apt update


sudo apt install -y \
    v4l-utils \
    ffmpeg \
    libopencv-dev \
    python3-opencv



########################################
# Python packages
########################################


source "$HOME/miniforge3/etc/profile.d/conda.sh"

conda activate lerobot


info "Installing python camera packages"


pip install -U \
    opencv-python \
    imageio \
    imageio-ffmpeg



########################################
# Video group
########################################


info "Adding user to video group"


sudo usermod -aG video "$USER"



########################################
# Detect cameras
########################################


echo

info "Detecting cameras"


if ls /dev/video* >/dev/null 2>&1
then

    ls -l /dev/video*

else

    warning "No camera device found"

fi



########################################
# v4l2 information
########################################


echo


if command -v v4l2-ctl >/dev/null
then

    info "Camera list"


    v4l2-ctl --list-devices || true


else

    warning "v4l2-ctl unavailable"

fi



########################################
# Camera permission
########################################


RULE="/etc/udev/rules.d/99-camera.rules"


info "Creating camera udev rule"


sudo tee $RULE >/dev/null <<EOF

SUBSYSTEM=="video4linux", GROUP="video", MODE="0666"

EOF



sudo udevadm control --reload-rules

sudo udevadm trigger




########################################
# OpenCV test
########################################


info "Testing OpenCV"


python <<EOF

import cv2


cap=cv2.VideoCapture(0)


if not cap.isOpened():

    print("Camera open failed")

else:

    ret,frame=cap.read()

    if ret:

        print("Camera OK")

        print(
            "Resolution:",
            frame.shape
        )

    else:

        print("Frame capture failed")


cap.release()

EOF



########################################
# LeRobot camera test
########################################


echo


info "Testing LeRobot camera discovery"



if command -v lerobot-find-cameras >/dev/null
then

    lerobot-find-cameras || true


else

    warning "lerobot-find-cameras not found"

fi




########################################
# Report
########################################


REPORT="$HOME/so101_camera_report.txt"


cat > $REPORT <<EOF

SO101 Camera Report
====================


Date:

$(date)



Video devices:

$(ls /dev/video* 2>/dev/null)



V4L2:

$(v4l2-ctl --list-devices 2>/dev/null)



User groups:

$(groups)



OpenCV:

$(python <<PY

import cv2

cap=cv2.VideoCapture(0)

print(cap.isOpened())

cap.release()

PY
)


EOF



success "Camera configuration finished"



echo

info "Report saved:"
echo "$REPORT"


warning "Logout/login required for video group."
