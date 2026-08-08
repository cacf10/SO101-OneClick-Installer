#!/usr/bin/env bash
#
# SO101-OneClick-Installer
#
# uninstall.sh
#
# Remove SO101 environment
#

set -euo pipefail



source "$(dirname "$0")/libs/colors.sh"
source "$(dirname "$0")/libs/logger.sh"



title "SO101 Uninstaller"



echo

echo "Choose uninstall mode:"

echo

echo "1) Remove LeRobot only"

echo "2) Remove conda environment"

echo "3) Full remove"

echo


read -p "Select [1-3]: " MODE



source "$HOME/miniforge3/etc/profile.d/conda.sh"



case $MODE in



1)


info "Removing LeRobot"


if [ -d "$HOME/lerobot" ]
then

rm -rf "$HOME/lerobot"

fi


;;



2)


info "Removing conda environment"


conda deactivate || true


conda env remove \
    -n lerobot \
    -y


;;



3)


warning "FULL REMOVE"


read -p \
"Delete Miniforge and all SO101 files? (yes/no): " CONFIRM



if [ "$CONFIRM" = "yes" ]
then


conda deactivate || true


rm -rf \
$HOME/miniforge3


rm -rf \
$HOME/lerobot


rm -rf \
$HOME/SO101-OneClick-Installer


rm -rf \
$HOME/.local/bin/so101-*


success "Removed everything"


else

echo "Cancelled"

fi


;;



*)

error "Invalid option"

exit 1


;;

esac



success "Uninstall completed"
