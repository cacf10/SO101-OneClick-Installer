#!/usr/bin/env bash

############################################################
# SO101-OneClick-Installer
#
# scripts/08_usb_offline.sh
#
# Completely Offline USB Setup
#
# IMPORTANT:
#   - NO apt update
#   - NO apt upgrade
#   - NO network access
#   - ONLY local .deb packages
############################################################

set -euo pipefail

############################################################
# Root directory
############################################################

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

############################################################
# Load libraries
############################################################

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"

############################################################
# Title
############################################################

title "STEP 8  USB Setup (Offline)"

############################################################
# Configuration
############################################################

APT_DIR="$ROOT_DIR/offline/apt"

USB_PACKAGES=(
    "libusb-1.0-0"
    "usbutils"
)

############################################################
# Helper
############################################################

require_file()
{
    local file="$1"

    if [[ ! -f "$file" ]]; then
        error "Required file missing:"
        error "$file"
        exit 1
    fi
}

############################################################
# Check offline directory
############################################################

info "Checking offline APT directory..."

if [[ ! -d "$APT_DIR" ]]; then
    error "Offline APT directory not found:"
    error "$APT_DIR"
    exit 1
fi

success "Offline APT directory found."

############################################################
# IMPORTANT NETWORK CHECK
############################################################

info "Offline mode enabled."

echo
echo "This step will NOT run:"
echo "  apt update"
echo "  apt upgrade"
echo "  apt-get update"
echo "  apt-get upgrade"
echo

############################################################
# Locate packages
############################################################

info "Checking local USB packages..."

LIBUSB_DEB=""

USBUTILS_DEB=""

############################################################
# Find libusb
############################################################

for file in "$APT_DIR"/libusb-1.0-0_*.deb
do
    if [[ -f "$file" ]]; then
        LIBUSB_DEB="$file"
        break
    fi
done

############################################################
# Find usbutils
############################################################

for file in "$APT_DIR"/usbutils_*.deb
do
    if [[ -f "$file" ]]; then
        USBUTILS_DEB="$file"
        break
    fi
done

############################################################
# Verify packages
############################################################

if [[ -z "$LIBUSB_DEB" ]]; then

    error "libusb-1.0-0 package not found."

    error "Expected:"
    error "$APT_DIR/libusb-1.0-0_*.deb"

    exit 1

fi

if [[ -z "$USBUTILS_DEB" ]]; then

    error "usbutils package not found."

    error "Expected:"
    error "$APT_DIR/usbutils_*.deb"

    exit 1

fi

success "libusb package found:"
echo "  $(basename "$LIBUSB_DEB")"

success "usbutils package found:"
echo "  $(basename "$USBUTILS_DEB")"

############################################################
# Install libusb
############################################################

info "Installing libusb from local package..."

sudo dpkg -i "$LIBUSB_DEB"

success "libusb installed."

############################################################
# Install usbutils
############################################################

info "Installing usbutils from local package..."

sudo dpkg -i "$USBUTILS_DEB"

success "usbutils installed."

############################################################
# Configure packages
############################################################

info "Configuring local packages..."

sudo dpkg --configure -a

success "Local packages configured."

############################################################
# Check lsusb
############################################################

echo

info "Checking USB utilities..."

if command -v lsusb >/dev/null 2>&1
then

    success "lsusb available."

else

    error "lsusb command not found."

    exit 1

fi

############################################################
# USB controller information
############################################################

echo
echo "USB controller information:"
echo

lsusb || true

############################################################
# Dialout group
############################################################

echo

info "Configuring serial permissions..."

if getent group dialout >/dev/null 2>&1
then

    success "dialout group exists."

else

    info "Creating dialout group..."

    sudo groupadd dialout

    success "dialout group created."

fi

############################################################
# Add current user
############################################################

CURRENT_USER="${USER:-$(id -un)}"

if id -nG "$CURRENT_USER" | tr ' ' '\n' | grep -qx "dialout"
then

    success "User '$CURRENT_USER' already belongs to dialout."

else

    info "Adding '$CURRENT_USER' to dialout..."

    sudo usermod -aG dialout "$CURRENT_USER"

    success "User added to dialout."

    echo
    warning "The dialout permission becomes active after a new login."
    warning "For WSL, restart the WSL instance if necessary."

fi

############################################################
# Serial device check
############################################################

echo

title "USB Serial Device Check"

FOUND_SERIAL=0

############################################################
# ACM
############################################################

for device in /dev/ttyACM*
do

    if [[ -e "$device" ]]; then

        success "Serial device detected: $device"

        FOUND_SERIAL=1

        ls -l "$device"

    fi

done

############################################################
# USB serial
############################################################

for device in /dev/ttyUSB*
do

    if [[ -e "$device" ]]; then

        success "Serial device detected: $device"

        FOUND_SERIAL=1

        ls -l "$device"

    fi

done

############################################################
# No device is NOT an error
############################################################

if [[ "$FOUND_SERIAL" -eq 0 ]]
then

    warning "No /dev/ttyACM* or /dev/ttyUSB* device detected."

    echo
    echo "This is NOT an installation failure."
    echo
    echo "Connect the SO101 controller later and run:"
    echo
    echo "  lsusb"
    echo
    echo "  ls -l /dev/ttyACM*"
    echo
    echo "  ls -l /dev/ttyUSB*"
    echo

else

    success "USB serial device check completed."

fi

############################################################
# USB permissions
############################################################

echo

info "Checking serial device permissions..."

if [[ "$FOUND_SERIAL" -eq 1 ]]
then

    for device in /dev/ttyACM* /dev/ttyUSB*
    do

        if [[ -e "$device" ]]; then

            ls -l "$device"

        fi

    done

else

    warning "No serial device available for permission check."

fi

############################################################
# Final verification
############################################################

echo

title "USB Offline Setup Summary"

echo

if command -v lsusb >/dev/null 2>&1
then
    success "USB utilities       : OK"
else
    error "USB utilities       : FAIL"
    exit 1
fi

if getent group dialout >/dev/null 2>&1
then
    success "dialout group       : OK"
else
    error "dialout group       : FAIL"
    exit 1
fi

if id -nG "$CURRENT_USER" | tr ' ' '\n' | grep -qx "dialout"
then
    success "dialout membership  : OK"
else
    warning "dialout membership  : PENDING"
fi

if [[ "$FOUND_SERIAL" -eq 1 ]]
then
    success "Serial device       : DETECTED"
else
    warning "Serial device       : NOT DETECTED"
fi

echo

success "STEP 8 Finished."

echo
echo "USB setup was completed entirely from local files."
echo "No package was downloaded from the Internet."
echo
