
mk_usb_installer.sh

./mk_usb_installer.sh usb-device <config-filename>

Make a usb installer:
  debian, preseed, ansible

note: not self contained.
It expects networking to get preseed, deb repos, late_command, ansible

usb-device: dev of usb stick to clobber (like sdc, no /dev/ prefex)

config-filename: settings to build the machine and run ansible
  distro/suite, where to get it, proxy
  where to get preseed file
  drive to install to (sda, nvme0n1...)
  nonfree firmware setting that I am affraid to hardcode
  ansible playbook and inventory repos


How to use:

 # sudo apt install git pmount dcfldd
 # fork and clone the inventory repo
 # adjust ansible inventory file, commit and push back to your public repo
 # cp mk_usb_installer.cfg mybox.cfg
 # vim mybox.cfg
 ## set inventory_repo to your public repo
 ## and consider the other 10 settings
 # ./mk_usb_installer.sh sdb mybox.cfg

 it will do this:
  a. setup bootable usb stick
  b. run a web server to serve up the preseed, early, late_command.sh

 Boot target machine from the usb stick.
 It will do this:
  a. install the OS using values from mybox.cfg and preseed.cfg
  b. wget/run late_command.sh
  c. late_command.sh will clone the repos
  d.  and run something like: ansible --local --limit=$(hostname)


cfg file settings:

 preseed - how the installer gets the file (defaults to http from this box)

Easy: leave this as is.
 it will use the server run at the end of this script.
preseed="url=$(hostname):8000"

no local dns:
 preseed="url=$(hostname).local:8000"
 preseed="url=10.100.7.247:8000"

Host the file on some other server hostname dc10b.
 your problem to setup the server, hostname whatever you want.
 preseed="url=dc10b"

Use the file on the usb stick
 early and late_command use $url, so do something about it.
 preseed="file=preseed.cfg"

Per box changes can be done by passing parameter to the kernel
 from the syslinux on the usb stick:
 example: to install to an SSD that doesn't come up as /dev/sda:

Where to get what:

suite=stretch
bootimg_loc=http://ftp.debian.org/debian/dists/${suite}/main/installer-amd64/current/images
iso=debian-9.0.0-amd64-netinst.iso
iso_loc=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/

 Ubuntu:
 suite=xenial  tested, put the iso on a 2nd usb stick.
 suite=zesty  not tested
 suite=artful  enough testing to make a machine boot
 bootimg_loc=http://archive.ubuntu.com/ubuntu/dists/${suite}/main/installer-amd64/current/images/
 bootimg_loc=http://archive.ubuntu.com/ubuntu/dists/${suite}-updates/main/installer-amd64/current/images/
 iso=ubuntu-16.04.2-server-amd64.iso
 iso_loc=http://releases.ubuntu.com/${suite}
 http://cdimage.ubuntu.com/ubuntu-server/daily/current/artful-server-amd64.iso
 iso=artful-server-amd64.iso
 iso_loc=http://cdimage.ubuntu.com/ubuntu-server/daily/current

