#!/bin/bash -ex

# build a usb installer: debian, preseed, ansible
# expects networking in order to get:
#   preseed, deb repos, late_command, ansible

# $1 - dev of usb stick to clobber (like sdc, no /dev/ prefex)
# $2 - filename of parameters

dev=$1

if [ ! -b "/dev/${dev}" ]; then
      echo "/dev/${dev} is not a block device."
      exit
fi

# default parameters that can be over ridden by passed file

preseed="url=$(hostname):8007"

disk=/dev/sda
bootdev=/dev/sda

hostname=testme
# domain=netme
load_firmware=false

playbook_repo=https://anonscm.debian.org/cgit/debconf-video/ansible.git
playbook_branch=master
inventory_repo=
inventory_branch=

# Anything else you want to append to the kernel.
more_appends=

# where to get installer binaries:

suite=stretch
bootimg_loc=http://ftp.debian.org/debian/dists/${suite}/main/installer-amd64/current/images
iso=debian-9.3.0-amd64-netinst.iso
iso_loc=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd

# end of default parameters.

(( $# >= 2 )) && source "$2"


appends="
${preseed} \\
partman-auto/disk=${disk} \\
grub-installer/bootdev=${bootdev} \\
hostname=${hostname} \\
domain=${domain} \\
hw-detect/load_firmware=${load_firmware} \\
lc/playbook_repo=${playbook_repo} \\
lc/playbook_branch=${playbook_branch} \\
lc/inventory_repo=${inventory_repo} \\
lc/inventory_branch=${inventory_branch} \\
${more_appends} \\
"

appends="${preseed}  partman-auto/disk=${disk}  grub-installer/bootdev=${bootdev}  hostname=${hostname}  domain=${domain}  hw-detect/load_firmware=${load_firmware}  lc/playbook_repo=${playbook_repo}  lc/playbook_branch=${playbook_branch}  lc/inventory_repo=${inventory_repo}  lc/inventory_branch=${inventory_branch} ${more_appends}"

cache=cache/${suite}
mkdir -p ${cache}

(cd ${cache}

# get and veriy the boot image
# (hd-media dir because that is bunred into the SHA256SUMS file)
wget -N --directory-prefix hd-media ${bootimg_loc}/hd-media/boot.img.gz
curl -OJ ${bootimg_loc}/SHA256SUMS
# pull the line out for the 1 file and verify it
grep ./hd-media/boot.img.gz SHA256SUMS > boot.img.gz.SHA256SUM
sha256sum --check boot.img.gz.SHA256SUM

# cd of local .deb's
wget -N ${iso_loc}/${iso}
curl -OJ ${iso_loc}/SHA256SUMS
grep ${iso} SHA256SUMS > ${iso}.SHA256SUM
sha256sum --check ${iso}.SHA256SUM
)

### zcat ${cache}/hd-media/boot.img.gz|sudo dcfldd of=/dev/${dev}

# mount the installer media
pmount /dev/${dev} ${dev}

# append $appends to APPEND line
# tee so we can see what gets written out.
sed "\|^APPEND|s|$| fb=false ${appends}|" syslinux.cfg | tee /media/${dev}/syslinux.cfg

# the preseed files that somehow will be served over the net.
ls ../roles/tftp-server/files/d-i/${suite}/*

case $suite in

    trusty|xenial|zenial)
        # bail here becuase the ubuntu iso doen't fit
        # boot.img only has 782M of free space.
        # The .iso is too big and sometimes boot is an iso9660 fs so RO?!!
        # so put it on a 2nd usb stick, or the unused space on the 8gig usb stick.
        echo "Your problem to get ${iso} on the target box."
        ;;

    *)

        ### cp ${cache}/${iso} ${cache}/${iso}.SHA256SUM /media/${dev}
        cd /media/${dev}
        # check the iso image again, make sure it copied ok.
        sha256sum --check ${iso}.SHA256SUM
        cd -
        ;;

esac

pumount /dev/${dev}

./http_server.sh
