#!/usr/bin/env bash
#
# SO101-OneClick-Installer
#
# repair.sh
#
# Repair existing environment
#

set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"



title "SO101 Repair Tool"



################################
# Check conda
################################


if [ ! -d "$HOME/miniforge3" ]
then

    error "Miniforge not found"

    exit 1

fi



source "$HOME/miniforge3/etc/profile.d/conda.sh"



################################
# Activate
################################


info "Activating environment"


conda activate lerobot



################################
# Repair system
################################


info "Repairing system dependencies"



sudo apt update


sudo apt install -y \
    python3-opencv \
    v4l-utils \
    ffmpeg \
    usbutils



################################
# Repair python packages
################################


info "Repair python packages"



pip install \
    --upgrade \
    pip \
    setuptools \
    wheel



################################
# Install locked packages
################################


if [ -f "$ROOT_DIR/config/conda.txt" ]
then

    info "Installing python dependencies"


    pip install \
        -r "$ROOT_DIR/config/conda.txt"


fi



################################
# Torch repair
################################


info "Repair torch"



source "$ROOT_DIR/scripts/06_torch.sh"



################################
# LeRobot repair
################################


info "Repair LeRobot"



cd "$HOME/lerobot"


pip install -e ".[feetech]"



################################
# USB repair
################################


info "Repair USB permissions"



sudo usermod -aG dialout $USER

sudo usermod -aG video $USER



################################
# Camera repair
################################


info "Repair camera"



bash "$ROOT_DIR/scripts/09_camera.sh"



################################
# Verify
################################


info "Running verification"


bash "$ROOT_DIR/scripts/10_verify.sh"



success "Repair finished"



echo

echo "Please restart WSL."
