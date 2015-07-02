#!/bin/bash

# Usage: sudo leomake.sh
# Only tested for LeoStick v2 (Caterina Bootloader).
# If you don't have this bootloader, you really should upgrade.

# you can remove the update line if you want
apt-get update;
# make sure we've got the things we need.
apt-get -y install arduino-mk python-serial zip;

cd /tmp;
wget -O leostick_master.zip https://github.com/freetronics/LeoStickBoardProfile/archive/master.zip;
unzip leostick_master.zip;
mkdir -p /root/sketchbook/hardware/leostick && cd $_;
cp LeoStickBoardProfile-master/* ./;
sed -i.bkp 's/arduino://' boards.txt

cd /usr/bin/share/arduino;
mkdir -p bin;

# backup the packaged Arduino.mk file in case you want it later
cp Arduino.mk Arduino.mk.bkp;

# update to latest makefile
wget -O Arduino.mk https://raw.githubusercontent.com/sudar/Arduino-Makefile/master/Arduino.mk;
wget -O Common.mk https://raw.githubusercontent.com/sudar/Arduino-Makefile/master/Common.mk;
wget -O bin/ard-reset-arduino https://raw.githubusercontent.com/sudar/Arduino-Makefile/master/bin/ard-reset-arduino;

# ard-reset-arduino needs to be executable. (It also needs python-serial.)
chmod -R 755 bin;

# Set up example project
mkdir -p /root/sketchbook/LeoBlink && cd $_;
cp /usr/share/arduino/examples/01.Basics/Blink/Blink.ino;
# Create Makefile
echo "BOARDS_TXT = ~/sketchbook/hardware/leostick/boards.txt
BOOTLOADER_PARENT = ~/sketchbook/hardware/leostick/bootloaders
BOOTLOADER_PATH = caterina
BOOTLOADER_FILE = Caterina-LeoStick.hex
BOARD_TAG = leostickv2

ARDUINO_PORT = /dev/ttyACM0
ARDUINO_DIR = /usr/share/arduino
ARDUINO_LIBS =

include /usr/share/arduino/Arduino.mk
" > Makefile;
chmod -R 755 /root/sketchbook/LeoBlink

# cleanup
rm /tmp/leostick_master.zip;
rm -rf /tmp/LeoStickBoardProfile-master;

echo "Setup complete. go to /root/sketchbook/LeoBlink to view example Makefile."
