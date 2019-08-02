#!/bin/sh

qemu-system-x86_64 \
    -vnc 0.0.0.0:0 \
    -m 512 \
    -hda $ROUTEROS_IMAGE \
    -device e1000,netdev=net0 \
    -netdev tap,id=net0,script=./qemu-ifup.sh
