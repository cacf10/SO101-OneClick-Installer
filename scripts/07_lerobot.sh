#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# scripts/07_lerobot.sh
#
# Install LeRobot
#

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/lib/colors.sh"
source "$ROOT_DIR/lib/logger.sh"

title "STEP 7  Install LeRobot"

#########################################
# Configuration
#########################################

ENV_NAME="lerobot"

CONDA_HOME="$HOME/miniforge3"

WORKSPACE="$HOME/projects"

LEROBOT_DIR="$WORKSPACE/lerobot"

LEROBOT_TAG="v0.6.1"

#########################################
# Activate Conda
#########################################

source "$CONDA_HOME/etc/profile.d/conda.sh"

conda activate "$ENV_NAME"

#########################################
# Check Torch
#########################################

info "Checking Torch..."

python <<EOF
import torch
print(torch.__version__)
EOF

#########################################
# Clone Repository
#########################################

mkdir -p "$WORKSPACE"

cd "$WORKSPACE"

if [[ ! -d "$LEROBOT_DIR" ]]
then

    info "Cloning LeRobot..."

    git clone https://github.com/huggingface/lerobot.git

fi

#########################################
# Checkout Version
#########################################

cd "$LEROBOT_DIR"

git fetch --all

git checkout ${LEROBOT_TAG}

#########################################
# Install Editable
#########################################

info "Installing editable..."

pip install -e .

#########################################
# Install Feetech
#########################################

info "Installing Feetech support..."

pip install -e ".[feetech]"

#########################################
# Verify
#########################################

python <<EOF

import lerobot

print("LeRobot OK")

EOF

#########################################
# CLI Test
#########################################

echo

lerobot-calibrate --help >/dev/null

lerobot-teleoperate --help >/dev/null

lerobot-record --help >/dev/null

lerobot-replay --help >/dev/null

success "CLI OK"

#########################################
# Robot Import
#########################################

python <<EOF

import lerobot

from lerobot.robots import *

print("Robot OK")

EOF

#########################################
# Dataset
#########################################

mkdir -p ~/datasets

mkdir -p ~/.cache/huggingface

#########################################
# Finished
#########################################

success "LeRobot Installed."
