#!/bin/sh

set -eux

# build a usb installer: debian, preseed, ansible
# expects networking in order to get:
#   preseed, deb repos, late_command, ansible, blobs

# $1 - dev of usb stick to clobber (like sdc, no /dev/ prefex)
# $2 - optional filename of parameters

dev=$1
if [ ! -b "/dev/${dev}" ]; then
      echo "error: /dev/${dev} is not a block device."
      exit
fi

# default parameters that can be over ridden by $2 passed config file

hostname=voctotest
domain=local.lan

# where to get what installer binaries:
suite=stretch
debian_ver=9.5.0
arch=amd64
bootimg_loc=http://deb.debian.org/debian/dists/${suite}/main/installer-${arch}/current/images
iso=debian-${debian_ver}-${arch}-netinst.iso
iso_loc=https://cdimage.debian.org/debian-cd/current/${arch}/iso-cd

# where to get the preseed file for the installer
# default: this machine running a python http server
preseed="url=$(hostname):8007"

# device on target machine to install and boot
disk=/dev/sda
bootdev=/dev/sda

# where to get ansible playbooks and inventory
playbook_repo=https://salsa.debian.org/debconf-video-team/ansible
playbook_branch=master
inventory_repo=
inventory_repo_dir=inventory

# ansible vault password (base64ed), if necessary
vault_pw=

# don't ask about firmware  (may be needed for network device)
load_firmware=false

# Anything else you want to append to the kernel.
more_appends=

# end of default parameters.

# if passed, load conf file
if [ $# -ge 2 ]; then
	. "$2"
fi

cat > ../roles/tftp-server/files/scripts/late_command.cfg <<EOF
# generated by mk_usb_installer.sh
# .gitignored
playbook_repo="$playbook_repo"
playbook_branch="$playbook_branch"
inventory_repo="$inventory_repo"
inventory_repo_dir="$inventory_repo_dir"
vault_pw="$vault_pw"
EOF

# construct kernel append for parameters passed to the installer
# both d-i values and repos for late_command/ansible.
appends=$(echo "
${preseed}
partman-auto/disk=${disk}
grub-installer/bootdev=${bootdev}
hostname=${hostname}
domain=${domain}
hw-detect/load_firmware=${load_firmware}
preseed/early_command=\"anna-install eatmydata-udeb\"
${more_appends}
" | tr '\n' ' ')

# where to save big download files
cache=cache/${suite}
mkdir -p ${cache}

(cd ${cache}

# get and veriy the boot image
# (hd-media dir because that is burned into the SHA256SUMS file)
wget -N --directory-prefix hd-media ${bootimg_loc}/hd-media/boot.img.gz
curl -OJL ${bootimg_loc}/SHA256SUMS
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
sed "\|^APPEND|s|$| fb=false ${appends}|" syslinux.cfg | tee /media/${dev}/syslinux.cfg

# skip over pesky ubuntu builds that don't play well
case $suite in
    trusty|xenial)
        # bail here becuase the ubuntu iso doen't fit
        # boot.img only has 782M of free space.
        # The .iso is too big and sometimes boot is an iso9660 fs so RO?!!
        # you will have to figure out how to put it on a 2nd usb stick,
        # or the unused space on the 8gig usb stick.
        echo "Your problem to get ${iso} on the target box."
        pumount /dev/${dev}
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
sync

echo Starting HTTP server. Please boot the target machine from the USB now.
./http_server.sh
