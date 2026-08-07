check_system(){

source /etc/os-release

echo_green "Ubuntu Version: $VERSION"

if [[ "$VERSION_ID" < "22.04" ]]; then

echo_red "Ubuntu version too old."

exit 1

fi

}
