sudo usermod -aG dialout $USER

sudo cp templates/udev.rules \
/etc/udev/rules.d/

sudo udevadm control --reload-rules
