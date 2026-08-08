#!/usr/bin/env bash
#
# SO101-OneClick-Installer
#
# scripts/08_usb.sh
#
# USB Serial Setup
#

set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"


title "STEP 8  Configure USB"


#########################################
# Check Linux
#########################################

if [[ ! -d /dev ]]
then
    error "No /dev found"
    exit 1
fi


#########################################
# Install USB tools
#########################################

info "Installing USB tools"


sudo apt update


sudo apt install -y \
    usbutils \
    udev \
    python3-serial


#########################################
# User group
#########################################

info "Adding user to dialout"


sudo usermod -aG dialout "$USER"


#########################################
# Detect serial devices
#########################################

echo

info "Current serial devices:"


ls -l /dev/ttyACM* 2>/dev/null || \
echo "No ttyACM devices found"


ls -l /dev/ttyUSB* 2>/dev/null || \
echo "No ttyUSB devices found"



#########################################
# udev rules
#########################################

RULE_FILE="/etc/udev/rules.d/99-so101.rules"


info "Creating udev rule"


sudo tee $RULE_FILE >/dev/null <<EOF

# SO101 Feetech USB Serial

KERNEL=="ttyACM*", MODE="0666", GROUP="dialout"

KERNEL=="ttyUSB*", MODE="0666", GROUP="dialout"

EOF



#########################################
# Reload udev
#########################################

sudo udevadm control --reload-rules

sudo udevadm trigger



#########################################
# USB Information
#########################################

echo

info "USB devices"


lsusb || true



#########################################
# Create workspace info
#########################################

REPORT="$HOME/so101_usb_report.txt"


cat > $REPORT <<EOF

SO101 USB Report
================

Date:
$(date)


User:
$USER


Serial devices:

$(ls /dev/ttyACM* 2>/dev/null)


$(ls /dev/ttyUSB* 2>/dev/null)


USB:

$(lsusb)


Groups:

$(groups)

EOF



success "USB configuration finished"


echo

warning "Please logout and login again for dialout group."

echo

info "Report saved:"
echo "$REPORT"
