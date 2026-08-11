#!/usr/bin/env bash

############################################################
#
# SO101-OneClick-Installer
#
# scripts/04_environment_offline.sh
#
# Restore Conda Environment Offline
#
# Version: 1.0.0
#
############################################################


set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "STEP 4  Restore Offline Environment"



############################################################
# Configuration
############################################################


CONDA_DIR="$HOME/miniforge3"

ENV_NAME="lerobot"

ENV_DIR="$CONDA_DIR/envs/$ENV_NAME"


PACKAGE="$ROOT_DIR/offline/environment/so101-lerobot-env.tar.gz"



############################################################
# Check Miniforge
############################################################


if [ ! -f "$CONDA_DIR/bin/conda" ]

then

    error "Miniforge not found."

    echo

    echo "Please run STEP 3 first."

    exit 1

fi



success "Miniforge detected"



############################################################
# Load conda
############################################################


source "$CONDA_DIR/etc/profile.d/conda.sh"



############################################################
# Check package
############################################################


if [ ! -f "$PACKAGE" ]

then

    error "Offline environment package missing:"

    echo "$PACKAGE"

    exit 1

fi



success "Offline package found"



############################################################
# Remove old environment
############################################################


if [ -d "$ENV_DIR" ]

then

    warning "Existing lerobot environment detected."

    warning "Removing old environment..."

    rm -rf "$ENV_DIR"

fi



############################################################
# Create env directory
############################################################


mkdir -p "$ENV_DIR"



############################################################
# Extract environment
############################################################


info "Extracting LeRobot environment..."



tar -xzf \
"$PACKAGE" \
-C "$ENV_DIR"



success "Environment extracted"



############################################################
# Fix conda-pack paths
############################################################


if [ -f "$ENV_DIR/bin/conda-unpack" ]

then

    info "Running conda-unpack..."

    "$ENV_DIR/bin/python" "$ENV_DIR/bin/conda-unpack"


    success "Environment repaired"

else

    warning "conda-unpack not found."

fi



############################################################
# Register environment
############################################################


info "Registering environment..."



conda env list | grep -q "$ENV_NAME" || true



conda config --append envs_dirs "$CONDA_DIR/envs"



success "Environment registered"



############################################################
# Verify Python
############################################################


PYTHON="$ENV_DIR/bin/python"



if [ ! -f "$PYTHON" ]

then

    error "Python not found."

    exit 1

fi



echo

info "Python Version"

"$PYTHON" --version



############################################################
# Verify packages
############################################################


echo

info "Testing PyTorch"



"$PYTHON" <<EOF

import torch

print("Torch:", torch.__version__)

print("CUDA:", torch.cuda.is_available())

EOF



echo


info "Testing LeRobot"



"$PYTHON" <<EOF

import lerobot

print("LeRobot OK")

print(lerobot.__file__)

EOF



############################################################
# Summary
############################################################


title "Offline Environment Summary"


echo

echo "Conda:"
echo "$CONDA_DIR"

echo

echo "Environment:"
echo "$ENV_DIR"

echo

echo "Python:"
"$PYTHON" --version


echo


success "STEP 4 Offline Environment Finished."
