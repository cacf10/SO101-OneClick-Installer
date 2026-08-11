#!/usr/bin/env bash

############################################################
#
# SO101-OneClick-Installer
#
# scripts/03_conda_offline.sh
#
# Offline Miniforge Installer
#
############################################################

set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"


title "STEP 3  Offline Install Miniforge"


############################################################
# Config
############################################################


INSTALL_DIR="$HOME/miniforge3"


MINIFORGE_INSTALLER="$ROOT_DIR/offline/miniforge/Miniforge3-Linux-x86_64.sh"



############################################################
# Check installer
############################################################


if [ ! -f "$MINIFORGE_INSTALLER" ]

then

    error "Miniforge installer missing"

    echo "$MINIFORGE_INSTALLER"

    exit 1

fi


success "Found Miniforge installer"



############################################################
# Install
############################################################


if [ -d "$INSTALL_DIR" ]

then

    warning "Miniforge already exists"

else


    info "Installing Miniforge offline..."


    bash "$MINIFORGE_INSTALLER" \
    -b \
    -p "$INSTALL_DIR"


    success "Miniforge installed"

fi



############################################################
# Initialize conda
############################################################


source "$INSTALL_DIR/etc/profile.d/conda.sh"



conda --version



success "Conda ready"



############################################################
# Configure bash
############################################################


if ! grep -q "miniforge3/etc/profile.d/conda.sh" "$HOME/.bashrc"
then


cat >> "$HOME/.bashrc" <<EOF


# >>> SO101 Offline Installer >>>

source $INSTALL_DIR/etc/profile.d/conda.sh

# <<< SO101 Offline Installer <<<

EOF


fi



success "Conda configured"



echo

success "STEP 3 Offline Finished"
