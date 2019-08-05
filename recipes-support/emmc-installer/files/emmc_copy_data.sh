#!/bin/sh

MACHINE=syrusrouter
DEV=/dev/mmcblk1p4

if [ ! -f ${SRCDIR}/data.tar ]; then
    echo "File not found: ${SRCDIR}/data.tar"
    exit 1
fi

if [ ! -b $DEV ]; then
    echo "Block device not found: $DEV"
    exit 1
fi

mount $DEV /media

tar xf ${SRCDIR}/data.tar -C /media --strip-components=1

mkdir /media/mender
export MACHINE
bash -c 'echo "device_type=${MACHINE}" > /media/mender/device_type'
chmod 444 /media/mender/device_type

umount $DEV
