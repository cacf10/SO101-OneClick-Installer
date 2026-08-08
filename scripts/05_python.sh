#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# scripts/05_python.sh
#
# Install Python Toolchain
#

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"

title "STEP 5  Install Python Toolchain"

##############################################
# Config
##############################################

ENV_NAME="lerobot"
CONDA_HOME="$HOME/miniforge3"

##############################################
# Load Conda
##############################################

if [[ ! -f "$CONDA_HOME/etc/profile.d/conda.sh" ]]; then
    error "Conda not found."
    exit 1
fi

source "$CONDA_HOME/etc/profile.d/conda.sh"

conda activate "$ENV_NAME"

success "Activated Conda environment: $ENV_NAME"

##############################################
# Upgrade pip
##############################################

info "Updating pip..."

python -m pip install \
    --upgrade \
    pip==25.1.1

##############################################
# Build tools
##############################################

info "Installing build tools..."

pip install \
    setuptools==80.9.0 \
    wheel==0.45.1 \
    build==1.3.0 \
    packaging==25.0

##############################################
# Compiler helpers
##############################################

info "Installing compiler helpers..."

pip install \
    cython \
    ninja \
    cmake \
    pybind11 \
    maturin

##############################################
# Development tools
##############################################

info "Installing developer packages..."

pip install \
    ipython \
    pytest \
    black \
    isort \
    flake8

##############################################
# Utilities
##############################################

info "Installing utilities..."

pip install \
    psutil \
    rich \
    tqdm \
    click \
    pyyaml \
    tomli \
    tomlkit

##############################################
# Cache
##############################################

mkdir -p ~/.cache/pip

pip cache dir

##############################################
# Check pip
##############################################

pip check || true

##############################################
# Show Versions
##############################################

echo
echo "==============================="
echo "Python Toolchain"
echo "==============================="

python --version
pip --version

python - <<EOF
import setuptools
import wheel
import packaging
import build

print("setuptools :", setuptools.__version__)
print("wheel      :", wheel.__version__)
print("packaging  :", packaging.__version__)
print("build      :", build.__version__)
EOF

##############################################
# Self Test
##############################################

python <<EOF
import sys
import pip
import setuptools
import wheel
import packaging

print()
print("Python Toolchain OK")
print(sys.executable)
EOF

##############################################
# Finished
##############################################

success "STEP 5 Finished."
