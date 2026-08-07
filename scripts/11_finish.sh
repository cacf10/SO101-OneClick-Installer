#!/usr/bin/env bash
#
# SO101-OneClick-Installer
#
# scripts/11_finish.sh
#
# Final setup summary
#

set -euo pipefail


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


source "$ROOT_DIR/lib/colors.sh"
source "$ROOT_DIR/lib/logger.sh"



title "STEP 11  Finish Installation"



####################################
# Environment
####################################


ENV_NAME="lerobot"

INSTALL_DIR="$HOME/SO101-OneClick-Installer"

REPORT="$HOME/so101_finish_report.txt"



####################################
# Create summary
####################################


cat > $REPORT <<EOF

SO101 OneClick Installer
========================


Installation finished:

$(date)



User:

$USER



Home:

$HOME



Environment:

$ENV_NAME



Installer:

$INSTALL_DIR


EOF



####################################
# Create helper commands
####################################


info "Creating SO101 helper commands"



BIN="$HOME/.local/bin"


mkdir -p $BIN



####################################
# activate command
####################################


cat > $BIN/so101-env <<EOF
#!/bin/bash

source \$HOME/miniforge3/etc/profile.d/conda.sh

conda activate lerobot

echo "SO101 environment activated"

EOF



####################################
# doctor command
####################################


cat > $BIN/so101-doctor <<EOF
#!/bin/bash

cd $INSTALL_DIR

./scripts/10_verify.sh

EOF



####################################
# usb check
####################################


cat > $BIN/so101-usb <<EOF
#!/bin/bash

echo "SO101 USB devices"

ls /dev/ttyACM* 2>/dev/null || echo "No SO101 USB found"

EOF



####################################
# permission
####################################


chmod +x \
$BIN/so101-env \
$BIN/so101-doctor \
$BIN/so101-usb



####################################
# PATH
####################################


if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]
then

cat >> ~/.bashrc <<EOF

export PATH=\$HOME/.local/bin:\$PATH

EOF

fi



####################################
# Finish message
####################################


echo


echo "=============================================="

echo "       SO101 LeRobot Ready"

echo "=============================================="


echo


success "Installation completed"



echo

echo "Environment:"
echo

echo "  Conda:"
echo "     conda activate lerobot"


echo

echo "Calibration:"

echo

echo "  Leader:"
echo

echo "  lerobot-calibrate \\"

echo "    --robot.type=so101_leader \\"

echo "    --robot.port=/dev/ttyACM0 \\"

echo "    --robot.id=leader_arm"


echo


echo "  Follower:"
echo

echo "  lerobot-calibrate \\"

echo "    --robot.type=so101_follower \\"

echo "    --robot.port=/dev/ttyACM1 \\"

echo "    --robot.id=follower_arm"



echo

echo "Teleoperate:"

echo

echo "lerobot-teleoperate \\"

echo " --robot.type=so101_follower \\"

echo " --robot.port=/dev/ttyACM1 \\"

echo " --teleop.type=so101_leader \\"

echo " --teleop.port=/dev/ttyACM0"



echo

echo "=============================================="

echo


warning "IMPORTANT"

echo

echo "Please restart WSL once:"

echo

echo "    exit"

echo

echo "Then reopen Ubuntu."



echo

info "Useful commands:"


echo

echo " so101-env"

echo "    Activate environment"


echo

echo " so101-doctor"

echo "    Check installation"


echo

echo " so101-usb"

echo "    Check USB ports"



echo


info "Report saved:"
echo "$REPORT"


echo


success "Enjoy your SO101 robot!"
