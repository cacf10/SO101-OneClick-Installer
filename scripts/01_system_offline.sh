#!/usr/bin/env bash

############################################################
#
# SO101-OneClick-Installer
#
# scripts/01_system_offline.sh
#
# Offline System Check
#
# No network
# No apt
# No package install
#
############################################################


set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"


title "STEP 1  Offline System Check"



############################################################
# Basic Information
############################################################

info "Collecting system information..."


echo

echo "====================================="
echo " System Information"
echo "====================================="


echo

echo "User:"
echo "$USER"


echo

echo "Home:"
echo "$HOME"


echo

echo "Hostname:"
hostname


echo

echo "Kernel:"
uname -a



############################################################
# Ubuntu Check
############################################################

echo

info "Checking Ubuntu..."



if [ -f /etc/os-release ]

then

    source /etc/os-release


    echo "Distribution:"
    echo "$NAME"


    echo "Version:"
    echo "$VERSION"



    if [[ "$ID" != "ubuntu" ]]

    then

        warning "This system is not Ubuntu"

    else

        success "Ubuntu detected"

    fi


else

    error "/etc/os-release missing"

    exit 1

fi



############################################################
# Ubuntu Version
############################################################


UBUNTU_VERSION=$(grep VERSION_ID /etc/os-release | cut -d '"' -f2)


echo

echo "Ubuntu Version:"
echo "$UBUNTU_VERSION"



if [[ "$UBUNTU_VERSION" < "22.04" ]]

then

    warning "Ubuntu version may be unsupported"

else

    success "Ubuntu version OK"

fi



############################################################
# WSL Detection
############################################################


echo

info "Checking WSL..."



if grep -qi microsoft /proc/version

then

    success "WSL detected"

else

    warning "Not running under WSL"

fi



############################################################
# CPU Architecture
############################################################


echo

info "Checking CPU architecture..."



ARCH=$(uname -m)


echo "Architecture:"
echo "$ARCH"



case "$ARCH" in


x86_64)

    success "x86_64 architecture"

    ;;


aarch64)

    warning "ARM64 architecture detected"

    ;;


*)

    error "Unsupported architecture: $ARCH"

    exit 1

    ;;


esac



############################################################
# Disk Space
############################################################


echo

info "Checking disk space..."



DISK_AVAILABLE=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')



echo "Available disk:"
echo "${DISK_AVAILABLE}GB"



if [ "$DISK_AVAILABLE" -lt 15 ]

then

    warning "Disk space may be insufficient"

else

    success "Disk space OK"

fi



############################################################
# Memory
############################################################


echo

info "Checking memory..."



if command -v free >/dev/null 2>&1

then


MEM_TOTAL=$(free -g | awk '/Mem:/ {print $2}')


echo "Memory:"
echo "${MEM_TOTAL}GB"



if [ "$MEM_TOTAL" -lt 8 ]

then

    warning "Less than 8GB RAM"

else

    success "Memory OK"

fi



else

    warning "free command unavailable"

fi



############################################################
# Offline Package Check
############################################################


echo

info "Checking offline resources..."



OFFLINE_DIR="$ROOT_DIR/offline"



if [ ! -d "$OFFLINE_DIR" ]

then

    error "offline directory missing"

    exit 1

fi



success "offline directory found"



############################################################
# Miniforge package
############################################################


MINIFORGE="$OFFLINE_DIR/miniforge/Miniforge3-Linux-x86_64.sh"



if [ -f "$MINIFORGE" ]

then

    success "Miniforge installer found"

else

    error "Missing Miniforge installer"

    echo "$MINIFORGE"

    exit 1

fi



############################################################
# Environment package
############################################################


ENV_PACKAGE="$OFFLINE_DIR/environment/so101-lerobot-env.tar.gz"



if [ -f "$ENV_PACKAGE" ]

then

    success "LeRobot environment package found"

else

    error "Missing LeRobot environment package"

    echo "$ENV_PACKAGE"

    exit 1

fi



############################################################
# Network Check
############################################################


echo

info "Checking network status..."



if command -v curl >/dev/null 2>&1

then


if curl -Is --connect-timeout 3 https://github.com >/dev/null 2>&1

then

    warning "Network is available"

    echo "Offline installation can continue"

else

    success "No network detected"

fi



else

    info "curl unavailable, skip network test"

fi



############################################################
# Summary
############################################################


echo

title "System Check Summary"


echo

echo "Ubuntu:"
echo "$VERSION"


echo "Architecture:"
echo "$ARCH"


echo "Disk:"
echo "${DISK_AVAILABLE}GB"


echo "Offline Package:"
echo "$OFFLINE_DIR"



echo


success "STEP 1 Offline System Check Finished"
