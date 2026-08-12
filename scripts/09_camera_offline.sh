#!/bin/bash

set -e

echo "======================================"
echo " SO101 Camera Offline Installer"
echo " Ubuntu 24.04 Noble"
echo "======================================"

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 项目根目录
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

CAMERA_DIR="$ROOT_DIR/offline/camera/apt"


echo "[INFO] Checking camera package directory..."

if [ ! -d "$CAMERA_DIR" ]; then
    echo "[ERROR] Camera package directory not found:"
    echo "$CAMERA_DIR"
    exit 1
fi


echo "[INFO] Packages found:"
ls -1 "$CAMERA_DIR"/*.deb


echo
echo "[INFO] Installing camera dependency packages..."

# 安装所有离线deb
# 第一次允许依赖未满足
sudo dpkg -i \
    "$CAMERA_DIR"/*.deb \
    || true


echo
echo "[INFO] Configuring packages..."

sudo dpkg --configure -a


echo
echo "[INFO] Checking installed packages..."

dpkg -l | grep -E \
"libjpeg|libv4l|v4l-utils" \
|| true


echo
echo "[INFO] Checking v4l-utils..."

if command -v v4l2-ctl >/dev/null 2>&1
then

    v4l2-ctl --version

else

    echo "[ERROR] v4l2-ctl not installed"
    exit 1

fi


echo
echo "======================================"
echo " Camera offline install completed"
echo "======================================"
