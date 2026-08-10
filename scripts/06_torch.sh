#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# scripts/06_torch.sh
#
# Install PyTorch (Locked Version)
#


source "$ROOT_DIR/libs/conda.sh"

load_conda

conda activate lerobot

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"

title "STEP 6  Install PyTorch"

##############################################
# Configuration
##############################################

ENV_NAME="lerobot"
CONDA_HOME="$HOME/miniforge3"

TORCH_VERSION="2.7.1"
TORCHVISION_VERSION="0.22.1"
TORCHAUDIO_VERSION="2.7.1"

##############################################
# Activate Conda
##############################################

source "$CONDA_HOME/etc/profile.d/conda.sh"

conda activate "$ENV_NAME"

##############################################
# Detect GPU
##############################################

GPU="cpu"

if command -v nvidia-smi >/dev/null 2>&1
then
    GPU="cuda"
fi

info "Device : $GPU"

##############################################
# Remove old Torch
##############################################

info "Removing old Torch..."

pip uninstall -y \
torch \
torchvision \
torchaudio \
triton \
nvidia-cublas-cu12 \
nvidia-cuda-runtime-cu12 \
nvidia-cuda-nvrtc-cu12 \
nvidia-cudnn-cu12 \
nvidia-cufft-cu12 \
nvidia-curand-cu12 \
nvidia-cusolver-cu12 \
nvidia-cusparse-cu12 \
nvidia-cupti-cu12 \
nvidia-nvjitlink-cu12 \
nvidia-nccl-cu12 \
nvidia-nvtx-cu12 \
nvidia-nvshmem-cu12 \
2>/dev/null || true

##############################################
# Clean Cache
##############################################

pip cache purge || true

##############################################
# Install Torch
##############################################

if [[ "$GPU" == "cpu" ]]
then

    info "Installing CPU version..."

    pip install \
        torch==${TORCH_VERSION} \
        torchvision==${TORCHVISION_VERSION} \
        torchaudio==${TORCHAUDIO_VERSION}

else

    info "Installing CUDA version..."

    pip install \
        torch==${TORCH_VERSION} \
        torchvision==${TORCHVISION_VERSION} \
        torchaudio==${TORCHAUDIO_VERSION}

fi

##############################################
# Verify
##############################################

python <<EOF

import torch

print("="*50)
print("Torch Version")
print(torch.__version__)

print("="*50)

print("CUDA Available")
print(torch.cuda.is_available())

if torch.cuda.is_available():

    print(torch.cuda.get_device_name(0))

EOF

##############################################
# Simple Tensor Test
##############################################

python <<EOF

import torch

x=torch.rand(3,3)

y=torch.rand(3,3)

print(x+y)

print("Tensor OK")

EOF

##############################################
# Finished
##############################################

success "STEP 6 Finished."
