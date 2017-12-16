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

# default parameters that can be over ridden by $2 passed config file

# where to get what installer binaries:
suite=stretch
arch=amd64
bootimg_loc=http://ftp.debian.org/debian/dists/${suite}/main/installer-${arch}/current/images
iso=debian-9.3.0-${arch}-netinst.iso
iso_loc=https://cdimage.debian.org/debian-cd/current/${arch}/iso-cd

# where to get the preseed file for the installer
# default: this machine running a python http server
preseed="url=$(hostname):8007"

# device on target machine to install and boot
disk=/dev/sda
bootdev=/dev/sda

# hostname of target (should be listed in ansible inventory/hosts)
hostname=testme

# this will come from dhcp, i think?
# domain=netme

# where to get ansible playbooks and inventory
playbook_repo=https://anonscm.debian.org/cgit/debconf-video/ansible.git
playbook_branch=master
inventory_repo=
inventory_branch=

# don't ask about firmwae  (may be needed for network device)
load_firmware=false

# Anything else you want to append to the kernel.
more_appends=

# end of default parameters.

# if passed, load conf file
(( $# >= 2 )) && source "$2"


# construct kernel append for parameters passed to the installer
# both d-i values and repos for late_command/ansible.
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

# above is pretty but doesn't work.  this works.
appends="${preseed}  partman-auto/disk=${disk}  grub-installer/bootdev=${bootdev}  hostname=${hostname}  domain=${domain}  hw-detect/load_firmware=${load_firmware}  lc/playbook_repo=${playbook_repo}  lc/playbook_branch=${playbook_branch}  lc/inventory_repo=${inventory_repo}  lc/inventory_branch=${inventory_branch} ${more_appends}"

# where to save big download files
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

# repo? (cd, file, bunch of bytes) of local .deb's
wget -N ${iso_loc}/${iso}
curl -OJ ${iso_loc}/SHA256SUMS
grep ${iso} SHA256SUMS > ${iso}.SHA256SUM
sha256sum --check ${iso}.SHA256SUM
)

zcat ${cache}/hd-media/boot.img.gz|sudo dcfldd of=/dev/${dev}

# mount the installer media
pmount /dev/${dev} ${dev}

# append $appends to APPEND line
sed --in-place "\|^APPEND|s|$| fb=false ${appends}|" /media/${dev}/syslinux.cfg

# skip over pesky ubuntu builds that don't play well
case $suite in

    trusty|xenial|zenial)
        # bail here becuase the ubuntu iso doen't fit
        # boot.img only has 782M of free space.
        # The .iso is too big and sometimes boot is an iso9660 fs so RO?!!
        # you will have to figure out how to put it on a 2nd usb stick,
        # or the unused space on the 8gig usb stick.
        echo "Your problem to get ${iso} on the target box."
        exit
        ;;

    *)
        cp ${cache}/${iso} ${cache}/${iso}.SHA256SUM /media/${dev}
        # check the iso file, make sure it copied ok.
        (cd /media/${dev}
        sha256sum --check ${iso}.SHA256SUM
        )
        ;;

esac

pumount /dev/${dev}

./http_server.sh
