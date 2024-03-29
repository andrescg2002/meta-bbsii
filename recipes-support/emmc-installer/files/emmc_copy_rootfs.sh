#!/bin/sh
#
# Script to install a system onto the eMMC.
# This script handles the root file system partition.
#
# Run it like this:
#
#  ./emmc_copy_rootfs.sh <image-file> [ <hostname> ]
#

MACHINE=syrusrouter
DEV=/dev/mmcblk1p2

if [ -z "${SRCDIR}" ]; then
        SRCDIR=.
else
        if [ ! -d "${SRCDIR}" ]; then
                echo "Source directory not found: ${SRCDIR}"
                exit 1
        fi
fi

if [ "x${1}" = "x" ]; then
    echo -e "\nUsage: ${0} <image-name> [<hostname>]\n"
    exit 0
fi

if [ ! -d /media ]; then
    echo "Mount point /media does not exist"
    exit 1
fi

if [ ! -b $DEV ]; then
    echo "Block device not found: $DEV"
    exit 1
fi

if [ -f "${1}" ]; then
    FULLPATH="${1}"
elif [ -f "${SRCDIR}/${1}" ]; then
    FULLPATH="${SRCDIR}/${1}"
elif [ -f "${SRCDIR}/${1}-${MACHINE}.tar.xz" ]; then
    FULLPATH="${SRCDIR}/${1}-${MACHINE}.tar.xz"
elif [ -f "${SRCDIR}/${1}-image-${MACHINE}.tar.xz" ]; then
    FULLPATH="${SRCDIR}/${1}-image-${MACHINE}.tar.xz"
else
    echo "Rootfs image file not found."
    echo "Tried the following:"
    echo "${1}"
    echo "${SRCDIR}/${1}"
    echo "${SRCDIR}/${1}-${MACHINE}.tar.xz"
    echo "${SRCDIR}/${1}-image-${MACHINE}.tar.xz"
    exit 1
fi

if [ "x${2}" = "x" ]; then
        TARGET_HOSTNAME=$MACHINE
else
        TARGET_HOSTNAME=${2}
fi

echo -e "HOSTNAME: $TARGET_HOSTNAME\n"

echo "Formatting $DEV as ext4"
mkfs.ext4 -q -F -L primary $DEV

echo "Mounting $DEV as /media"
mount $DEV /media

echo "Extracting ${FULLPATH} to  /media"
EXTRACT_UNSAFE_SYMLINKS=1 tar -C /media -xJf ${FULLPATH}

#echo "Generating a random-seed for urandom"
#mkdir -p /media/var/lib/urandom
#dd if=/dev/urandom of=/media/var/lib/urandom/random-seed bs=512 count=1
#chmod 600 /media/var/lib/urandom/random-seed

#echo "Writing hostname to /etc/hostname"
#export TARGET_HOSTNAME
#echo ${TARGET_HOSTNAME} > /media/etc/hostname

#if [ -f ${SRCDIR}/interfaces ]; then
#   echo "Writing interfaces to /media/etc/network/"
#    cp ${SRCDIR}/interfaces /media/etc/network/interfaces
#fi

#if [ -f ${SRCDIR}/wpa_supplicant.conf ]; then
#    echo "Writing wpa_supplicant.conf to /media/etc/"
#    cp ${SRCDIR}/wpa_supplicant.conf /media/etc/wpa_supplicant.conf
#fi

echo "Unmounting $DEV"
umount $DEV

DEV=/dev/mmcblk1p3

echo "Formatting $DEV as ext4"
mkfs.ext4 -q -F -L secondary $DEV

echo "Mounting $DEV as /media"
mount $DEV /media

echo "Extracting ${FULLPATH} to  /media"
EXTRACT_UNSAFE_SYMLINKS=1 tar -C /media -xJf ${FULLPATH}

echo "Unmounting $DEV"
umount $DEV

echo "Done"
