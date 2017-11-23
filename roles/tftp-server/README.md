# tftp-server

Install and manage the TFTP server.

## Tasks

Tasks are separated in two different parts:

* `tasks/d-i.yml` manages the d-i preesed options for the PXE boot.

* `tasks/webserver.yml` configures nginx to server the PXE files.

## Available variables

Main variables are :

* `netboot_image`:         URL of the `.tar.gz` netboot file for the PXE.

* `time_zone`:             The timezone of your machine.

* `domain`:                The DHCP domain.

* `apt_proxy`:             Boolean. If true, d-i will use the configured apt
                           proxy for the installation.

* `debian_source`:         The Debian source you want to use.

* `debian_version`:        The codename of the version of Debian you want to use.

* `user_name`:             The username d-i will use during the installation.

* `user_password_crypted`: The user's password d-i will use during the
                           installation.

* `playbook_repo`:         Full URL of the ansible git repository to use as late
                           command after the installation.

* `playbook_branch`:       Branch of said git repository to use.

* `inventory_repo`:        Full URL of the ansible inventory to use.

* `inventory_branch`:      Branch of said git repository to use.
