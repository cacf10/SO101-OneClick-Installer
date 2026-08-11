#!/usr/bin/env bash

set -e


ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$ROOT_DIR/libs/colors.sh"
source "$ROOT_DIR/libs/logger.sh"


title "STEP 1 Offline System Check"


echo

echo "Ubuntu:"
lsb_release -a


echo

echo "Kernel:"
uname -a


echo

echo "Disk:"
df -h /


success "System check finished"
