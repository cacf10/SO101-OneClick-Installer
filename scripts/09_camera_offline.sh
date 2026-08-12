#!/usr/bin/env bash

############################################################
# SO101-OneClick-Installer
#
# scripts/09_camera_offline.sh
#
# Completely Offline Camera Setup
#
# IMPORTANT:
#   - NO apt update
#   - NO apt upgrade
#   - NO network access
#   - ONLY local .deb packages
############################################################

set -euo pipefail

############################################################
# Root directory
############################################################

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

############################################################
# Libraries
############################################################

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"

############################################################
# Title
############################################################

title "STEP 9  Camera Setup (Offline)"

############################################################
# Configuration
############################################################

APT_DIR="$ROOT_DIR/offline/apt"

V4L2_DEB=""

############################################################
# Check offline directory
############################################################

info "Checking offline APT directory..."

if [[ ! -d "$APT_DIR" ]]; then

    error "Offline APT directory not found:"
    error "$APT_DIR"

    exit 1

fi

success "Offline APT directory found."

############################################################
# Offline mode
############################################################

info "Offline mode enabled."

echo
echo "This step will NOT access:"
echo "  archive.ubuntu.com"
echo "  security.ubuntu.com"
echo "  pypi.org"
echo "  github.com"
echo
echo "Only local packages will be used."
echo

############################################################
# Find v4l-utils
############################################################

for file in "$APT_DIR"/v4l-utils_*.deb
do

    if [[ -f "$file" ]]; then

        V4L2_DEB="$file"

        break

    fi

done

############################################################
# Verify package
############################################################

if [[ -z "$V4L2_DEB" ]]; then

    error "v4l-utils package not found."

    error "Expected:"
    error "$APT_DIR/v4l-utils_*.deb"

    exit 1

fi

success "v4l-utils package found:"
echo "  $(basename "$V4L2_DEB")"

############################################################
# Install v4l-utils
############################################################

info "Installing v4l-utils from local package..."

sudo dpkg -i "$V4L2_DEB"

success "v4l-utils installed."

############################################################
# Configure packages
############################################################

info "Configuring local packages..."

sudo dpkg --configure -a

success "Local packages configured."

############################################################
# Check v4l2-ctl
############################################################

info "Checking V4L2 utilities..."

if command -v v4l2-ctl >/dev/null 2>&1
then

    success "v4l2-ctl available."

else

    error "v4l2-ctl command not found."

    exit 1

fi

############################################################
# Display V4L2 version
############################################################

echo

v4l2-ctl --version || true

############################################################
# Detect video devices
############################################################

echo

title "Camera Device Check"

CAMERA_FOUND=0

for device in /dev/video*
do

    if [[ -e "$device" ]]; then

        success "Video device detected: $device"

        CAMERA_FOUND=1

    fi

done

############################################################
# No camera is NOT installation failure
############################################################

if [[ "$CAMERA_FOUND" -eq 0 ]]
then

    warning "No /dev/video* device detected."

    echo
    echo "This is NOT an installation failure."
    echo
    echo "If the camera is connected later, run:"
    echo
    echo "  ls /dev/video*"
    echo
    echo "  v4l2-ctl --list-devices"
    echo

else

    success "Video device detected."

fi

############################################################
# V4L2 device information
############################################################

if [[ "$CAMERA_FOUND" -eq 1 ]]
then

    echo

    info "V4L2 device information:"

    v4l2-ctl --list-devices || true

fi

############################################################
# OpenCV check
############################################################

echo

title "OpenCV Camera Check"

PYTHON="python"

if ! command -v "$PYTHON" >/dev/null 2>&1
then

    warning "Python command not available in current shell."

else

    if "$PYTHON" -c "import cv2" >/dev/null 2>&1
    then

        success "OpenCV import OK."

    else

        error "OpenCV import failed."

        exit 1

    fi

fi

############################################################
# OpenCV camera test
############################################################

if [[ "$CAMERA_FOUND" -eq 1 ]]
then

    info "Testing OpenCV camera access..."

    if "$PYTHON" - <<'PY'
import cv2
import sys

camera = cv2.VideoCapture(0)

if not camera.isOpened():
    camera.release()
    sys.exit(1)

ok, frame = camera.read()

camera.release()

if not ok or frame is None:
    sys.exit(1)

print("OpenCV camera frame OK")
PY
    then

        success "OpenCV camera test OK."

    else

        warning "OpenCV could not capture a frame."

        echo
        echo "The camera device exists, but frame capture failed."
        echo "Check camera permissions and WSL USB passthrough."

    fi

else

    warning "Camera hardware not connected."
    warning "Skipping frame capture test."

fi

############################################################
# Final summary
############################################################

echo

title "Camera Offline Setup Summary"

if command -v v4l2-ctl >/dev/null 2>&1
then

    success "V4L2 utilities : OK"

else

    error "V4L2 utilities : FAIL"

    exit 1

fi

if "$PYTHON" -c "import cv2" >/dev/null 2>&1
then

    success "OpenCV         : OK"

else

    error "OpenCV         : FAIL"

    exit 1

fi

if [[ "$CAMERA_FOUND" -eq 1 ]]
then

    success "Camera device  : DETECTED"

else

    warning "Camera device  : NOT DETECTED"

fi

echo

success "STEP 9 Finished."

echo
echo "Camera setup was completed without network access."
