#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# scripts/03_conda.sh
#
# Install Miniforge / Conda
#

set -euo pipefail

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

PYTHON_VERSION="3.12"

############################################################
# Check Conda
############################################################

if command -v conda >/dev/null 2>&1
then
    success "Conda already installed."
else

    info "Downloading Miniforge..."

    cd /tmp

    if [[ ! -f "$MINIFORGE_FILE" ]]
    then
        wget -O "$MINIFORGE_FILE" "$DOWNLOAD_URL"
    fi

    success "Download completed."

    info "Installing Miniforge..."

    bash "$MINIFORGE_FILE" -b -p "$INSTALL_DIR"

    success "Miniforge installed"

    $INSTALL_DIR/bin/conda init bash

    # Enable conda immediately
    source "$INSTALL_DIR/etc/profile.d/conda.sh"

    # Add auto load for future shells
    if ! grep -q "miniforge3/etc/profile.d/conda.sh" ~/.bashrc
    then

    cat >> ~/.bashrc <<EOF

    # >>> SO101 Installer >>>
    source $INSTALL_DIR/etc/profile.d/conda.sh
    # <<< SO101 Installer <<<

    EOF

    fi

    success "Conda initialized"

    # enable conda immediately
    source "$INSTALL_DIR/etc/profile.d/conda.sh"

    success "Conda loaded into current shell"
fi

############################################################
# Initialize Conda
############################################################

info "Initializing Conda..."

source "$INSTALL_DIR/etc/profile.d/conda.sh"

conda init bash >/dev/null

############################################################
# Reload shell
############################################################

export PATH="$INSTALL_DIR/bin:$PATH"

############################################################
# Verify
############################################################

conda --version

success "Conda initialized."

############################################################
# Update conda
############################################################

info "Updating Conda..."

conda update -y conda

############################################################
# Create Environment
############################################################

if conda env list | grep -q "^${ENV_NAME}"
then

    success "Environment '${ENV_NAME}' already exists."

else

    info "Creating environment..."

    conda create -y \
        -n ${ENV_NAME} \
        python=${PYTHON_VERSION}

    success "Environment created."

fi

############################################################
# Activate
############################################################

source "$INSTALL_DIR/etc/profile.d/conda.sh"

conda activate ${ENV_NAME}

############################################################
# Verify Python
############################################################

info "Python Version"

python --version

############################################################
# Upgrade pip
############################################################

python -m pip install --upgrade pip

############################################################
# Install wheel tools
############################################################

pip install \
wheel \
setuptools==80.9.0 \
packaging

############################################################
# Verify
############################################################

python - <<EOF
import sys
print("Python :",sys.version)
EOF

############################################################
# Conda Clean
############################################################

conda clean -y --all

############################################################
# Summary
############################################################

title "Conda Summary"

echo

echo "Install Path : $INSTALL_DIR"

echo "Environment  : $ENV_NAME"

echo "Python       : $(python --version)"

echo

success "STEP 3 Finished."

