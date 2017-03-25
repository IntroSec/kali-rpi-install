#!/bin/bash

################################################################################
#
#    filename: kali-rpi-install.sh
# description: Script to put image on SDcard of RPI2/3
#     version: v1.0.1
#      author: Andre Mattie
#       email: devel@introsec.ca
#         GPG: 5620 A200 6534 B779 08A8  B22B 0FA6 CD54 93EA 430D
#     bitcoin: 1LHsfZrES8DksJ41JAXULimLJjUZJf7Qns
#        date: 03/24/2017
#
################################################################################

# variables
DEVICE="$1"
FILE="kali-2.1.2-rpi2.img.xz"
IMAGE="kali-2.1.2-rpi2.img"
SHA1SUM="db36fcd53c630fd32f2f8943dddd9f57b3673c5a"
CHECKSUM="kali-2.1.2-rpi2.img.xz.sha1"
VERIFY=`sha1sum -c $CHECKSUM | awk '{print $2}'`

# ensure user is root
if [ "$(id -u)" -ne "0" ] ; then
    echo "You must be root to run this script"
    exit 0
fi

function DOWNLOAD {
	wget https://images.offensive-security.com/arm-images/kali-2.1.2-rpi2.img.xz
	return
}

function INSTALL {
	cd ~/tmp
	`dd if=$IMAGE of=$DEVICE bs=512k`
	return
}

if [ -z "$1" ]
then
	echo "Usage: kali-inst-rpi3.sh [sdcard location]"
	echo "Example; ./kali-inst-rpi3.sh /dev/mmcblk0"
fi

# make tmp folder and cd into it
mkdir ~/tmp
cd ~/tmp

# download Kali image for RPI2/3
if [ ! -f $FILE ];
then
	echo "The file $FILE in not found. downloading file now..."
	DOWNLOAD
else
	echo "The file $FILE exists."
fi


# verify downloaded image
echo -e "$SHA1SUM $FILE" > $CHECKSUM
echo "Checking file: $FILE"
echo "Using SHA1 file: $CHECKSUM"

if [ "$VERIFY" != "OK" ];
then
	echo "SHA1 sums dont match, file if corrupted. Please re-download the image"
else
	# unzip image is checksums are good
	echo "checksums OK"
	echo "Decompressing Kali image"
	xz -d $FILE
	echo "Decompression of Kali image finished"
	echo "Installing image to $DEVICE"
	INSTALL
fi

# Print confirmation that install is complete
echo ''
echo ''
echo "Kali Linux for Raspberry Pi 2/3 has finished installing"
echo ''
echo ''

exit 0