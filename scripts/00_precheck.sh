#!/usr/bin/env bash
#
# SO101-OneClick-Installer
# 00_precheck.sh
#
# 检查安装环境
#

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"
source "$ROOT_DIR/libs/utils.sh"

LOG_FILE="$ROOT_DIR/install.log"

title "STEP 0  Environment Precheck"

source "$ROOT_DIR/libs/conda.sh"

load_conda

conda activate lerobot

###########################################################
# Root Check
###########################################################

if [[ "$EUID" == 0 ]]; then
    error "Do NOT run this installer as root."
    exit 1
fi

###########################################################
# sudo
###########################################################

info "Checking sudo..."

if ! sudo -n true 2>/dev/null; then
    warning "sudo password will be required."
    sudo -v
fi

success "sudo OK"

###########################################################
# Ubuntu
###########################################################

info "Checking operating system..."

if [[ ! -f /etc/os-release ]]; then
    error "Unsupported Linux."
    exit 1
fi

source /etc/os-release

echo "Detected:"
echo "    $PRETTY_NAME"

case "$ID" in
    ubuntu)
        ;;
    *)
        error "Only Ubuntu is supported."
        exit 1
        ;;
esac

success "Ubuntu OK"

###########################################################
# WSL
###########################################################

info "Checking WSL..."

if grep -qi microsoft /proc/version; then
    success "Running under WSL"
else
    warning "Not running inside WSL"
fi

###########################################################
# Architecture
###########################################################

info "Checking CPU..."

ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        success "Architecture: x86_64"
        ;;
    aarch64)
        success "Architecture: ARM64"
        ;;
    *)
        warning "Unknown architecture: $ARCH"
        ;;
esac

###########################################################
# Memory
###########################################################

info "Checking RAM..."

TOTAL_RAM=$(free -g | awk '/Mem:/ {print $2}')

echo "RAM : ${TOTAL_RAM} GB"

if (( TOTAL_RAM < 4 )); then
    warning "Less than 4GB memory."
fi

###########################################################
# Disk
###########################################################

info "Checking disk..."

FREE_DISK=$(df -BG "$HOME" | awk 'NR==2{print $4}' | sed 's/G//')

echo "Free disk : ${FREE_DISK} GB"

if (( FREE_DISK < 20 )); then
    warning "Less than 20GB disk space."
fi

###########################################################
# Internet
###########################################################

info "Checking internet..."

if ping -c 1 mirrors.tuna.tsinghua.edu.cn >/dev/null 2>&1; then
    success "Network OK"
else
    warning "Network unreachable."
fi

###########################################################
# Commands
###########################################################

info "Checking required commands..."

CMD_LIST=(
git
curl
wget
tar
gzip
unzip
python3
)

for cmd in "${CMD_LIST[@]}"
do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf "  %-12s OK\n" "$cmd"
    else
        printf "  %-12s Missing\n" "$cmd"
    fi
done

###########################################################
# USB
###########################################################

info "Checking USB devices..."

USB_COUNT=$(ls /dev/ttyACM* 2>/dev/null | wc -l || true)

echo "Detected ttyACM devices : $USB_COUNT"

###########################################################
# Camera
###########################################################

info "Checking camera..."

CAMERA_COUNT=$(ls /dev/video* 2>/dev/null | wc -l || true)

echo "Detected cameras : $CAMERA_COUNT"

###########################################################
# Conda
###########################################################

info "Checking Conda..."

if command -v conda >/dev/null 2>&1; then

    success "Conda installed"

    conda --version

else

    warning "Conda not installed."

fi

###########################################################
# Python
###########################################################

info "Checking Python..."

if command -v python3 >/dev/null 2>&1; then

    python3 --version

fi

###########################################################
# Existing lerobot
###########################################################

info "Checking LeRobot..."

if python3 - <<EOF >/dev/null 2>&1
import lerobot
EOF
then
    success "LeRobot installed."
else
    warning "LeRobot not installed."
fi

###########################################################
# Workspace
###########################################################

info "Creating workspace..."

mkdir -p "$HOME/Downloads"

mkdir -p "$HOME/projects"

mkdir -p "$HOME/.cache"

mkdir -p "$ROOT_DIR/logs"

success "Workspace ready"

###########################################################
# Summary
###########################################################

title "System Summary"

echo
echo "OS        : $PRETTY_NAME"
echo "CPU       : $ARCH"
echo "RAM       : ${TOTAL_RAM} GB"
echo "Disk      : ${FREE_DISK} GB"
echo "USB       : ${USB_COUNT}"
echo "Camera    : ${CAMERA_COUNT}"
echo

success "Precheck completed."
