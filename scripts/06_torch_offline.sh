#!/usr/bin/env bash

############################################################
#
# SO101-OneClick-Installer
#
# scripts/06_torch_offline.sh
#
# Offline PyTorch Verify
#
############################################################


set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "STEP 6  Verify PyTorch Offline"



############################################################
# Environment
############################################################


CONDA_HOME="$HOME/miniforge3"

ENV_NAME="lerobot"

PYTHON="$CONDA_HOME/envs/$ENV_NAME/bin/python"



if [ ! -f "$PYTHON" ]

then

    error "Python environment not found"

    exit 1

fi



success "Python environment detected"



############################################################
# Torch Import
############################################################


info "Checking PyTorch..."



$PYTHON - <<EOF

import torch

print("--------------------------------")
print("PyTorch Version:")
print(torch.__version__)

print()

print("CUDA Available:")
print(torch.cuda.is_available())

print()

if torch.cuda.is_available():

    print("CUDA Device:")
    print(torch.cuda.get_device_name(0))

else:

    print("Running on CPU")

print("--------------------------------")


EOF



if [ $? -eq 0 ]

then

    success "PyTorch import OK"

else

    error "PyTorch import failed"

    exit 1

fi



############################################################
# TorchVision
############################################################


info "Checking torchvision..."



$PYTHON - <<EOF

import torchvision

print("torchvision:")
print(torchvision.__version__)

EOF



success "torchvision OK"



############################################################
# CUDA Libraries
############################################################


echo

info "Checking CUDA runtime..."



$PYTHON - <<EOF

import torch

print("CUDA version:")
print(torch.version.cuda)

EOF



############################################################
# Package Location
############################################################


echo

info "Torch location:"


$PYTHON - <<EOF

import torch

print(torch.__file__)

EOF



############################################################
# Finish
############################################################


echo

success "STEP 6 PyTorch Offline Finished"
