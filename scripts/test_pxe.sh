#!/bin/sh

set -ex

lan_dev=p3p1

# sudo apt install qemu qemu-system-x86 brctl

qemu-img create -f vmdk cache/testpxe.vmdk 10

sudo ip tuntap add dev virttap mode tap user $USER
sudo brctl addbr virtbr

sudo brctl addif virtbr $lan_dev
sudo brctl addif virtbr virttap
sudo ip link set virtbr up
sudo ip link set $lan_dev up
sudo ip link set virttap up

qemu-system-x86_64 -m 1024 -hda cache/testpxe.vmdk \
	  -boot n \
	  -option-rom /usr/share/qemu/pxe-rtl8139.rom \
	  -net nic \
	  -net tap,ifname=virttap,script=no,downscript=no
	# -display curses
