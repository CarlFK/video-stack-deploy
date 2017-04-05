#!/bin/bash -ex

# build a usb installer: debian, preseed, ansible

iso=debian-8.7.1-amd64-netinst.iso
dev=sdc

wget -N http://ftp.nl.debian.org/debian/dists/stable/main/installer-amd64/current/images/hd-media/boot.img.gz
wget -N http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/$iso

wget -N http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/SHA512SUMS


# zcat boot.img.gz|sudo dcfldd of=/dev/$dev conv=fdatasync

pmount /dev/$dev
cp $iso syslinux.cfg preseed.cfg /media/$dev

cd /media/$dev
sha512sum --check <(grep $iso $OLDPWD/SHA512SUMS)
cd -

pumount $dev



