#!/bin/bash -ex

# build a usb installer: debian, preseed, ansible
# expects networking in order to get:
#   preseed, deb repos, late_command, ansible

# $1 - dev of usb stick to clobber (like sdc, no /dev/ prefex)
dev=$1

# $2 - filename of parameters
cfg_name=${2:-mk_usb_installer.cfg}

source $cfg_name

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
"

appends="${preseed}  partman-auto/disk=${disk}  grub-installer/bootdev=${bootdev}  hostname=${hostname}  domain=${domain}  hw-detect/load_firmware=${load_firmware}  lc/playbook_repo=${playbook_repo}  lc/playbook_branch=${playbook_branch}  lc/inventory_repo=${inventory_repo}  lc/inventory_branch=${inventory_branch} "

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

zcat hd-media/boot.img.gz|sudo dcfldd of=/dev/${dev}
# or good ol dd
# zcat boot.img.gz|sudo dd of=/dev/${dev} conv=fdatasync

pmount /dev/${dev}

# append appends to append
# tee so we can see what gets written out.
sed "\|^APPEND|s|$| fb=false ${appends}|" syslinux.cfg | tee /media/${dev}/syslinux.cfg

# copy the preseed files in case of problems serving them over the net.
# just fix the kernel APPEND and the remove the early/late commands.
# (good luck, it is hard.)
cp -a ../roles/tftp-server/files/d-i/${suite}/* /media/${dev}

case $suite in

    xenial|zenial)
        # bail here becuase the ubuntu iso doen't fit
        # boot.img only has 782M of free space.
        # The .iso is too big and sometimes boot is an iso9660 fs so RO?!!
        # so put it on a 2nd usb stick, or the unused space on the 8gig usb stick.
        echo "Your problem to get ${iso} on the target box."
        ;;

    *)

        cp ${iso} ${iso}.SHA256SUM /media/${dev}
        cd /media/${dev}
        # check the iso image again, make sure it copied ok.
        sha256sum --check ${iso}.SHA256SUM
        cd -
        ;;

esac

pumount /dev/${dev}

./http_server.sh
