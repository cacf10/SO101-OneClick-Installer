#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# scripts/02_mirror.sh
#
# Configure mirrors
#

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"

title "STEP 2  Configure Mirrors"

###########################################################
# Load config
###########################################################

MIRROR="${MIRROR:-tsinghua}"

###########################################################
# Backup
###########################################################

info "Backing up old configuration..."

mkdir -p ~/.config/installer_backup

[[ -f ~/.pip/pip.conf ]] && cp ~/.pip/pip.conf ~/.config/installer_backup/

[[ -f ~/.condarc ]] && cp ~/.condarc ~/.config/installer_backup/

success "Backup finished."

###########################################################
# Mirror URL
###########################################################

case "$MIRROR" in

tsinghua)

PIP_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

CONDA_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda"

APT_URL="https://mirrors.tuna.tsinghua.edu.cn/ubuntu"

;;

ustc)

PIP_URL="https://pypi.mirrors.ustc.edu.cn/simple"

CONDA_URL="https://mirrors.ustc.edu.cn/anaconda"

APT_URL="https://mirrors.ustc.edu.cn/ubuntu"

;;

aliyun)

PIP_URL="https://mirrors.aliyun.com/pypi/simple"

CONDA_URL="https://mirrors.aliyun.com/anaconda"

APT_URL="https://mirrors.aliyun.com/ubuntu"

;;

official)

PIP_URL="https://pypi.org/simple"

CONDA_URL="https://repo.anaconda.com"

APT_URL=""

;;

*)

error "Unknown mirror."

exit 1

;;

esac

###########################################################
# pip
###########################################################

info "Configuring pip..."

mkdir -p ~/.pip

cat > ~/.pip/pip.conf <<EOF
[global]
index-url = ${PIP_URL}
trusted-host = $(echo ${PIP_URL} | awk -F/ '{print $3}')
timeout = 120
EOF

success "pip configured."

###########################################################
# Conda
###########################################################

if command -v conda >/dev/null 2>&1
then

info "Configuring conda..."

cat > ~/.condarc <<EOF
channels:
  - defaults

show_channel_urls: true

default_channels:
  - ${CONDA_URL}/pkgs/main
  - ${CONDA_URL}/pkgs/r

custom_channels:
  conda-forge: ${CONDA_URL}/cloud
EOF

success "conda configured."

fi

###########################################################
# Git
###########################################################

info "Configuring git..."

git config --global http.postBuffer 1048576000

git config --global core.compression 0

git config --global http.lowSpeedLimit 0

git config --global http.lowSpeedTime 999999

success "git configured."

###########################################################
# apt mirror (optional)
###########################################################

if [[ "$APT_URL" != "" ]]
then

info "APT mirror available."

echo

echo "Ubuntu mirror :"

echo "$APT_URL"

echo

warning "APT source will NOT be modified automatically."

warning "If required run change_apt_source.sh manually."

fi

###########################################################
# Test
###########################################################

title "Testing Mirrors"

echo

echo "pip"

pip config list || true

echo

if command -v conda >/dev/null 2>&1
then

echo "conda"

conda config --show-sources || true

fi

echo

success "Mirror configuration completed."
