#!/usr/bin/env bash

############################################################
#
# SO101-OneClick-Installer
#
# scripts/05_python_offline.sh
#
# Offline Python Verify
#
############################################################


set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "STEP 5  Verify Python Offline"



############################################################
# Conda
############################################################


CONDA_HOME="$HOME/miniforge3"

ENV_NAME="lerobot"

ENV_DIR="$CONDA_HOME/envs/$ENV_NAME"



if [ ! -d "$ENV_DIR" ]

then

    error "Conda environment missing"

    exit 1

fi


success "Environment found"



############################################################
# Python
############################################################


PYTHON="$ENV_DIR/bin/python"



if [ ! -f "$PYTHON" ]

then

    error "Python not found"

    exit 1

fi



success "Python found"



echo

$PYTHON --version



############################################################
# Pip
############################################################


info "Checking pip..."



$PYTHON -m pip --version



success "pip OK"



############################################################
# Package Verify
############################################################


echo

info "Checking Python packages..."



check_package()
{

PACKAGE=$1


if $PYTHON -c "import $PACKAGE" >/dev/null 2>&1

then

    success "$PACKAGE OK"

else

    error "$PACKAGE missing"

    exit 1

fi

}



check_package numpy

check_package torch

check_package torchvision

check_package cv2

check_package safetensors

check_package tqdm



############################################################
# Python path
############################################################


echo

info "Python location:"


$PYTHON - <<EOF

import sys

print(sys.executable)

print(sys.version)

EOF



############################################################
# Finish
############################################################


echo

success "STEP 5 Python Offline Finished"
