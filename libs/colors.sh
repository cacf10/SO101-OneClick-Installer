RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
NC="\033[0m"

echo_red(){
echo -e "${RED}$1${NC}"
}

echo_green(){
echo -e "${GREEN}$1${NC}"
}

echo_blue(){
echo -e "${BLUE}$1${NC}"
}

echo_yellow(){
echo -e "${YELLOW}$1${NC}"
}
