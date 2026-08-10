#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# scripts/04_environment.sh
#
# Configure LeRobot Environment
#


source "$ROOT_DIR/libs/conda.sh"

load_conda

conda activate lerobot

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"

title "STEP 4  Configure Python Environment"

###############################################
# Configuration
###############################################

ENV_NAME="lerobot"

MINIFORGE="$HOME/miniforge3"

###############################################
# Load Conda
###############################################

if [[ ! -f "$MINIFORGE/etc/profile.d/conda.sh" ]]; then
    error "Conda not found."

    exit 1
fi

source "$MINIFORGE/etc/profile.d/conda.sh"

conda activate "$ENV_NAME"

success "Activated environment: $ENV_NAME"

###############################################
# Upgrade pip
###############################################

info "Updating pip..."

python -m pip install \
--upgrade \
pip

###############################################
# Upgrade build tools
###############################################

info "Installing build tools..."

pip install \
wheel \
build \
packaging \
setuptools==80.9.0

###############################################
# Install common python libraries
###############################################

info "Installing Python utilities..."

pip install \
numpy==2.2.6 \
scipy \
matplotlib \
pillow \
pyyaml \
rich \
tqdm \
requests \
psutil \
typing_extensions

###############################################
# Install OpenCV
###############################################

info "Installing OpenCV..."

pip install \
opencv-python \
opencv-python-headless

###############################################
# Install Serial
###############################################

info "Installing serial libraries..."

pip install \
pyserial \
pyusb

###############################################
# Install Camera
###############################################

info "Installing camera libraries..."

pip install \
imageio \
imageio-ffmpeg

###############################################
# Install Notebook (optional)
###############################################

if [[ "${INSTALL_NOTEBOOK:-false}" == "true" ]]; then

pip install \
jupyter \
ipykernel \
notebook

fi

###############################################
# Install Git LFS
###############################################

if command -v git >/dev/null 2>&1
then

info "Checking Git LFS..."

if ! command -v git-lfs >/dev/null 2>&1
then

sudo apt-get install -y git-lfs

fi

git lfs install

fi

###############################################
# Create Cache
###############################################

mkdir -p ~/.cache

mkdir -p ~/.cache/huggingface

mkdir -p ~/.cache/torch

mkdir -p ~/.cache/opencv

###############################################
# Environment Variables
###############################################

grep -q HF_HOME ~/.bashrc || cat >> ~/.bashrc <<EOF

# SO101 Installer
export HF_HOME=\$HOME/.cache/huggingface
export TORCH_HOME=\$HOME/.cache/torch
export PYTHONUNBUFFERED=1
export PYTHONUTF8=1

EOF

###############################################
# USB Permissions
###############################################

sudo usermod -aG dialout "$USER"

###############################################
# Check Imports
###############################################

python <<EOF
import cv2
import serial
import numpy
import yaml
import tqdm

print("OpenCV :",cv2.__version__)
print("NumPy  :",numpy.__version__)
print("Environment OK")
EOF

###############################################
# Generate Environment Report
###############################################

python <<EOF

import sys
import platform
import os

print("="*50)

print("Python")
print(sys.version)

print("="*50)

print("Platform")
print(platform.platform())

print("="*50)

print("Executable")
print(sys.executable)

print("="*50)

print("Environment")

for k in [
"HF_HOME",
"TORCH_HOME"
]:
    print(k,"=",os.environ.get(k))

EOF

###############################################
# Finished
###############################################

success "Python environment configured."

title "STEP 4 Finished."
