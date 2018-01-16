# staticips

Manages `/etc/interface` and `/etc/hosts` files.
Using this module disables the hosts management function in the
`dhcp-server` role.

## Tasks

Tasks are separated in two different parts:

* `tasks/interfaces.yml` manages the network interface.

* `tasks/hosts.yml` manages the hosts file.

## Available variables

Main variables are :

* `staticips.gateway`:        Gateway for the DHCP server to advertise
                              (Default: self)
* `staticips.hosts`:          A list of machines that may be PXE imaged.
  Each item is a dictionary of:
  - `hostname`:               Hostname of the machines.
  - `ip`:                     IP Address.
  - `mac`:                    Ethernet MAC address.
  - `comment`:                A text comment field.
  - `tasks`:                  List of extra tasks to install.
  - `disk`:                   Path to the primary install disk.
                              (Defaults to the `default_install_disk`
                               variable)
* `staticips.write_hosts`:    Boolean. Write the contents of
                              `staticips.hosts` into `/etc/hosts`.
* `staticips.write_interfaces: Boolean. Write the machine's details into
                              `/etc/network/interfaces` rather than using
                              DHCP.
