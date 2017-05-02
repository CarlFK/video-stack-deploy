#!/bin/bash -ex

# build a usb installer: debian, preseed, ansible

# iso=debian-stretch-DI-rc3-amd64-netinst.iso
iso=ubuntu-17.04-server-amd64.iso

dev=sdc


# wget -N http://ftp.debian.org/debian/dists/stretch/main/installer-amd64/current/images/hd-media/boot.img.gz
# wget -N http://cdimage.debian.org/cdimage/stretch_di_rc3/amd64/iso-cd/$iso
# wget -N http://cdimage.debian.org/cdimage/stretch_di_rc3/amd64/iso-cd/SHA512SUMS

wget -N http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/hd-media/boot.img.gz
wget -N http://releases.ubuntu.com/zesty/$iso
wget -N http://releases.ubuntu.com/zesty/SHA256SUMS

sha256sum --check <(grep $iso SHA256SUMS)

echo pumount /dev/$dev
sudo dcfldd if=$iso of=/dev/$dev
exit

zcat boot.img.gz|sudo dcfldd of=/dev/$dev
# conv=fdatasync

pmount /dev/$dev
cp $iso syslinux.cfg d-i/jessie/preseed.cfg /media/$dev

# set the default so we can have special boot disks and such passed as boot parameters
sed -i "/^DEFAULT.*/s/^.*$/DEFAULT $1/" /media/$dev/syslinux.cfg

cd /media/$dev
# sha512sum --check <(grep $iso $OLDPWD/SHA512SUMS)
sha256sum --check <(grep $iso $OLDPWD/SHA256SUMS)
cd -

pumount $dev



