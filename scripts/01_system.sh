#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# scripts/01_system.sh
#
# 安装系统基础依赖
#

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"

title "STEP 1  Install System Packages"

source "$ROOT_DIR/libs/conda.sh"

load_conda

conda activate lerobot

#############################################
# 更新 apt
#############################################

info "Updating apt..."

sudo apt-get update

success "APT updated."

#############################################
# 升级软件包（可关闭）
#############################################

if [[ "${FULL_UPGRADE:-false}" == "true" ]]; then
    info "Running full upgrade..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    success "Upgrade completed."
fi

#############################################
# 基础工具
#############################################

info "Installing basic packages..."

sudo apt-get install -y \
build-essential \
git \
curl \
wget \
vim \
nano \
htop \
tree \
zip \
unzip \
tar \
gzip \
cmake \
pkg-config

success "Basic packages installed."

#############################################
# Python 编译依赖
#############################################

info "Installing Python build dependencies..."

sudo apt-get install -y \
libffi-dev \
libssl-dev \
zlib1g-dev \
libbz2-dev \
libreadline-dev \
libsqlite3-dev \
libncursesw5-dev \
libgdbm-dev \
liblzma-dev \
uuid-dev \
tk-dev

success "Python dependencies installed."

#############################################
# OpenCV
#############################################

info "Installing OpenCV dependencies..."

sudo apt-get install -y \
ffmpeg \
libsm6 \
libxext6 \
libgl1 \
libgtk-3-0 \
libopencv-dev

success "OpenCV dependencies installed."

#############################################
# Camera
#############################################

info "Installing camera tools..."

sudo apt-get install -y \
v4l-utils \
cheese

success "Camera tools installed."

#############################################
# USB
#############################################

info "Installing USB tools..."

sudo apt-get install -y \
usbutils \
udev \
libusb-1.0-0-dev

success "USB packages installed."

#############################################
# Serial
#############################################

info "Installing serial tools..."

sudo apt-get install -y \
minicom \
screen

success "Serial packages installed."

#############################################
# Network
#############################################

info "Installing network utilities..."

sudo apt-get install -y \
net-tools \
openssh-client \
openssh-server \
iputils-ping

success "Network packages installed."

#############################################
# Image Libraries
#############################################

info "Installing image libraries..."

sudo apt-get install -y \
libjpeg-dev \
libpng-dev \
libtiff-dev

success "Image libraries installed."

#############################################
# Video
#############################################

info "Installing video codecs..."

sudo apt-get install -y \
gstreamer1.0-tools \
gstreamer1.0-libav \
gstreamer1.0-plugins-good \
gstreamer1.0-plugins-base

success "Video packages installed."

#############################################
# USB 权限
#############################################

info "Adding current user to dialout group..."

sudo usermod -aG dialout "$USER"

success "dialout group configured."

#############################################
# Locale
#############################################

info "Configuring locale..."

sudo locale-gen en_US.UTF-8

sudo update-locale LANG=en_US.UTF-8

success "Locale configured."

#############################################
# Timezone
#############################################

if [[ -n "${TIMEZONE:-}" ]]; then

    info "Setting timezone..."

    sudo timedatectl set-timezone "$TIMEZONE"

fi

#############################################
# apt cleanup
#############################################

info "Cleaning apt cache..."

sudo apt-get autoremove -y

sudo apt-get autoclean -y

success "APT cleaned."

#############################################
# Summary
#############################################

title "Installed Versions"

git --version || true

curl --version | head -1 || true

cmake --version | head -1 || true

ffmpeg -version | head -1 || true

python3 --version || true

echo

success "STEP 1 Finished."
