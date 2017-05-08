#!/bin/bash -ex

# give user rw to usb device
# (need to logout/in for this to take affect.)
# or do some other trick that I don't think will let the script run :p
sudo adduser juser disk

# blank disk to install to
qemu-img create -f qcow2 disk.cow 8G

# run the installer
# (don't forget to run the server that hosts the preseed files)

# watch for the "press esc for boot menu" - hit Esc, 2
qemu-system-x86_64 -m 256 \
    -drive file=disk.cow,index=0 \
    -drive file=/dev/sdb,index=1 \
    -boot menu=on

