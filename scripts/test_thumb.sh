#!/bin/bash -ex

# give user rw to usb device
# sudo adduser juser disk
# (need to logout/in for this to take affect.)
# or do some other trick that I don't think will let the script run :p

# def of usb stick
dev=$1

# blank disk to install to
qemu-img create -f qcow2 disk.cow 8G

# run the installer
# (don't forget to run the server that hosts the preseed files)

# watch for the "press esc for boot menu" - hit Esc, 2
qemu-system-x86_64 -m 256 \
    -display curses \
    -drive file=disk.cow,index=0 \
    -drive file=/dev/${dev},index=1,format=raw,if=none,id=thumb \
      -device ide-hd,drive=thumb,bootindex=1

