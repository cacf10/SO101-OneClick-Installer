#!/usr/bin/env bash

set -euo pipefail


############################################################
# SO101-OneClick-Installer
# scripts/03_conda.sh
#
# Install Miniforge
############################################################


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "STEP 3  Install Miniforge"



############################################################
# Configuration
############################################################


MINIFORGE_VERSION="25.3.1-0"

MINIFORGE_FILE="Miniforge3-Linux-x86_64.sh"


DOWNLOAD_URL="https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_FILE}"


INSTALL_DIR="$HOME/miniforge3"

ENV_NAME="lerobot"



############################################################
# Detect Offline Package
############################################################


OFFLINE_INSTALLER="$ROOT_DIR/offline/$MINIFORGE_FILE"



############################################################
# Install Miniforge
############################################################


if [ -f "$INSTALL_DIR/bin/conda" ]; then


    success "Miniforge already installed"


else


    info "Installing Miniforge"



    if [ -f "$OFFLINE_INSTALLER" ]; then


        info "Using offline Miniforge installer"


        bash "$OFFLINE_INSTALLER" \
        -b \
        -p "$INSTALL_DIR"


    else


        info "Downloading Miniforge"


        cd /tmp


        wget -O "$MINIFORGE_FILE" \
        "$DOWNLOAD_URL"



        bash "$MINIFORGE_FILE" \
        -b \
        -p "$INSTALL_DIR"


    fi



    success "Miniforge installed"


fi



############################################################
# Conda command
############################################################


CONDA="$INSTALL_DIR/bin/conda"



if [ ! -f "$CONDA" ]; then

    echo_red "Conda installation failed"

    exit 1

fi



echo "$($CONDA --version)"



############################################################
# Configure bashrc
############################################################


if ! grep -q "SO101 Conda" "$HOME/.bashrc"
then


cat >> "$HOME/.bashrc" <<EOF


# >>> SO101 Conda >>>
source $INSTALL_DIR/etc/profile.d/conda.sh
# <<< SO101 Conda <<<

EOF


fi



############################################################
# Create environment
############################################################


if "$CONDA" env list | grep -q "^${ENV_NAME}"
then


    success "Environment exists: $ENV_NAME"


else


    info "Creating environment"


    "$CONDA" create \
    -y \
    -n "$ENV_NAME" \
    python=3.12



    success "Environment created"


fi



############################################################
# Install basic tools
############################################################


ENV_PYTHON="$INSTALL_DIR/envs/$ENV_NAME/bin/python"


"$ENV_PYTHON" -m pip install \
--upgrade \
pip \
wheel \
"setuptools==80.9.0" \
packaging



############################################################
# Summary
############################################################


title "Conda Summary"


echo

echo "Conda:"
echo "$CONDA"


echo

echo "Environment:"
echo "$INSTALL_DIR/envs/$ENV_NAME"


echo

echo "Python:"
"$ENV_PYTHON" --version



success "STEP 3 Finished."
