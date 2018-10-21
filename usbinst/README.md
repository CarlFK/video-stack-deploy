# Scripts

The scripts in this directory accomplish various tasks to do with setting up
the initial USB installer and testing the setup using QEMU.

## `mk_usb_installer.sh`

Makes a USB installer that loads a pressed and runs ansible. Currently supports
Debian. It is not self contained. It expects networking to get the preseed, deb
repos, `late_command` and ansible.

    ./mk_usb_installer.sh usb-device [config-filename]

`usb-device`: dev of usb stick to clobber with no `/dev/` prefix (for example
sdc).

`config-filename`: settings to build the machine and run ansible:
  - distro/suite, where to get it, proxy
  - where to get preseed file
  - drive to install to (sda, nvme0n1...)
  - non-free firmware setting that I am afraid to hardcode
  - ansible playbook and inventory repos

### How to use

1. `sudo apt install curl git pmount dcfldd`
2. fork and clone the inventory repo
3. adjust ansible inventory file, host and group vars, commit and push back to
   your public repo
4. `cd usbinst`
5. `cp configs/blank.cfg configs/mybox.cfg`
6. `vim configs/mybox.cfg`
   - set `inventory_repo` to your public repo
   - set `inventory_branch` to your public repo's branch
   - set `hostname` to the target's hostname
   - and consider the other settings.
7. `./mk_usb_installer.sh sdb configs/mybox.cfg`

`mk_usb_installer.sh` script will:
  * setup bootable usb stick
  * run a web server to serve up the preseed, early, `late_command.sh`

Boot target machine from the usb stick.
It will do this:
  * install the OS using values from `mybox.cfg` and `preseed.cfg`
  * `wget/run late_command.sh`
  * `late_command.sh` will clone the repos
  * and run something like: `ansible --local --limit=$(hostname)`

### Configuration File:


**hostname** - what the hostame will be.  used by ansible (see above.) udefaults to voctotest, which will bring up a simple vocto box.  To make the installer prompt, add a "?" to syslinux.cfg like this: hostname?=

**suit** - distro suite to use (stretch)

**arch** - architecture of the target machine (amd64)

**booting\_loc** - location of the boot images with the `SA256SUMS` and
`hd-media/boot.img.gz` files (http://deb.debian.org/debian/dists/${suite}/main/installer-${arch}/current/images)

**debian_ver** - debian version, currently 9.5.0.
**iso** - the ISO name to download (debian-${debian_ver}-${arch}-netinst.iso)

**iso\_loc** - the URL to the directory containing the ISO. (https://cdimage.debian.org/debian-cd/current/${arch}/iso-cd)

**preseed** - how the installer gets the file (defaults to http from this box).
There are several different options for this.

Easy:

Leave this as is. It will use the server run at the end of this script.

    preseed="url=$(hostname):8007"

No local DNS:

    preseed="url=$(hostname).local:8007"
    preseed="url=10.100.7.247:8007"

Host the file on some other server hostname dc10b:

Set the other server up and point the configuration to its hostname.

    preseed="url=dc10b"

Use the file on the USB stick:

`early_command` and `late_command` use `$url`, so they will changing in the
script.

    preseed="file=preseed.cfg"

**disk** - the device on the target machine to install onto (/dev/sda)

**bootdev** - the device on the target machine to boot from (/dev/sda)

**playbook\_repo** - the repo containing the playbooks for setting up the target
machine (https://salsa.debian.org/debconf-video-team/ansible)

**playbook\_branch** - the git branch in the playbook repo to use (master)

**inventory\_repo** - the repo containing the inventory/hosts file to use. If
it is blank, the playbook repo is used.

**inventory\_branch** - the git branch in the inventory repo to use. If it is
blank, the playbook repo branch is used.

**vault\_pw** - the password for ansible vault encoded in base64

**load\_firmware** - prompt about firmware in the installer (false)

**more\_appends** - additional configuration to be appended to the kernel

### Supported Distributions

#### Debian

This is the default configuration and does not require a configuration file if
none of the defaults need to be changed

#### Ubuntu

The default Xenial configuration is in `configs/xenial.cfg`. This can be
used for Artful by changing the suite. Unfortunately the Xenial ISO is too big
to fit, as `boot.img` only has 782M of free space. Thus `mk_usb_installer.sh`
will be unable to create a USB for Xenial. The config is kept here for when we
find a way of fixing this bug.

## `http_server.sh`

This runs an HTTP server so that the USB installer can pull the configuration
into the install. The configuration is written to the
[../roles/tftp-server/files/](../roles/tftp-server/files) directory by the
`mk_usb_installer.sh` script.

## `test_pxe.sh`

This tests the PXE booting environment by booting it in a qemu x86\_64 system.

    $ ./test_pxe.sh

It requires qemu and brctl

    $ sudo apt install qemu brctl

## `test_thumb.sh`

This tests the USB stick by booting it in a qemu x86\_64 system. It takes one
argument - the device, without the preceding `/dev/`. If the USB is `/dev/sdb`:

    $ ./test_thumb.sh sdb

It requires qemu:
    $ sudo apt install qemu
