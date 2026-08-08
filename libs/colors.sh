#!/usr/bin/env bash

# ============================================================
# SO101-OneClick-Installer
# libs/colors.sh
# Common terminal colors and output helpers
# ============================================================

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
NC="\033[0m"

echo_red() {
    echo -e "${RED}$*${NC}"
}

echo_green() {
    echo -e "${GREEN}$*${NC}"
}

echo_yellow() {
    echo -e "${YELLOW}$*${NC}"
}

echo_blue() {
    echo -e "${BLUE}$*${NC}"
}

echo_cyan() {
    echo -e "${CYAN}$*${NC}"
}

# ------------------------------------------------------------
# Standard installer messages
# ------------------------------------------------------------

title() {
    echo
    echo_blue "============================================================"
    echo_blue " $*"
    echo_blue "============================================================"
}

info() {
    echo_blue "[INFO] $*"
}

success() {
    echo_green "[✓] $*"
}

warning() {
    echo_yellow "[WARNING] $*"
}

error() {
    echo_red "[ERROR] $*"
}

