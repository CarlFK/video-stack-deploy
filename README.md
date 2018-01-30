# Setup and Testing the Setup

There are a few setup workflows that try to share common files.
There are different preseed and `late_comand.sh` files for Debian/Ubuntu and
USB/PXE, they are all very similar, maybe they can be merged later. The
playbooks defined in this repo require ansible version 2.4 or greater to run.
In Debian Stretch, this is available in backports.

1. Clone repo to your local machine.
2. Edit `inventory/hosts` and `inventory/{group,host}_vars`
3. Decide where the files will be hosted. The choices are:
     - Local machine using http server
     - Some other machine using http, either local or the cloud
     - Copy to USB stick (only makes sense for USB stick install)
     - Copy to PXE server (only make sense for PXE installs)

4. Make a USB stick. Even if you are going to do PXE installs, you need to build
   the PXE server using a USB. Details on how to create the USB stick can be
   found [here](scripts/README.md)
5. Boot a target machine from USB stick. The installer will ask for a hostname.
   That will install OS and run Ansible for that `$hostname`.

The result is a machine ready to be used in production.
