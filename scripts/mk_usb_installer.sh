#!/bin/bash -ex

# build a usb installer: debian, preseed, ansible

# dev of usb stick (like sdc, no /dev/ prefex)
# warning it gets clobbered.
dev=sdc

# use the supplied ./http_server.sh
preseed="url=$(hostname):8000"

# host the file on some other server hostname dc10b.
# your problem to setup the server, hostname whatever you want.
# preseed="url=dc10b"

# to use the file on the usb stick
# (early/late_command will need to be adjusted too)
# preseed="file=preseed.cfg"

# per box changes can be done by passing parameter to the kernel
# from the syslinux on the usb stick:
# example: to install to an SSD that doesn't come up as /dev/sda:
# (don't forget to escape the slasses because bash)
# appends='partman-auto\/disk=\/dev\/nvme0n1'

# where to get what:

suite=stretch
bootimg_loc=http://ftp.debian.org/debian/dists/${suite}/main/installer-amd64/current/images
iso=debian-stretch-DI-rc3-amd64-netinst.iso
iso_loc=http://cdimage.debian.org/cdimage/stretch_di_rc3/amd64/iso-cd

# suite=xenial
# bootimg_loc=http://archive.ubuntu.com/ubuntu/dists/${suite}/main/installer-amd64/current/images/
# iso=ubuntu-16.04.2-server-amd64.iso
# iso_loc=http://releases.ubuntu.com/${suite}

# the rest should just work.

# get and veriy the boot image
# (hd-media dir because that is bunred into the SHA256SUMS file)
wget -N --directory-prefi hd-media ${bootimg_loc}/hd-media/boot.img.gz
curl -OJ ${bootimg_loc}/SHA256SUMS
# pull the line out for the 1 file and verify it
grep hd-media/boot.img.gz SHA256SUMS > boot.img.gz.SHA256SUM
sha256sum --check boot.img.gz.SHA256SUM

# cd so most of the .deb's are local
wget -N ${iso_loc}/${iso}
curl -OJ ${iso_loc}/SHA256SUMS
grep ${iso} SHA256SUMS > ${iso}.SHA256SUM
sha256sum --check ${iso}.SHA256SUM

zcat hd-media/boot.img.gz|sudo dcfldd of=/dev/${dev}
# or good ol dd
# zcat boot.img.gz|sudo dd of=/dev/${dev} conv=fdatasync

pmount /dev/${dev}

# append appends to append, preseed location too.
# tee so I can see what gets written out.
sed "/^APPEND/s/$/ ${preseed} ${appends}/" syslinux.cfg | tee /media/${dev}/syslinux.cfg

# copy the preseed files in case of problems serving them over the net.
# 'just' fis the APPAND line and the early/late stuff and off you go.
cp -a d-i/${suite}/* /media/${dev}

# this doesn't work for Ubuntu.
# The .iso is too big and sometimes boot is an iso9660 fs so RO?!!
# boot.img only has 782M of free space.
# so put it on a 2nd usb stick, or the unused space on the 8gig usb stick.
cp ${iso} ${iso}.SHA256SUM /media/${dev}

cd /media/${dev}

# check the iso image again, make sure it copied ok.
sha256sum --check ${iso}.SHA256SUM

cd -
pumount /dev/${dev}

