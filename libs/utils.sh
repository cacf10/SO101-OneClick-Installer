command_exists(){

command -v "$1" >/dev/null 2>&1

}

ask_yes_no(){

read -p "$1 (y/n): " ans

[[ "$ans" == "y" ]]

}
