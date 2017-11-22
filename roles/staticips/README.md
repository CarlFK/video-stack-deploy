# staticips

Manages `/etc/interface` and `/etc/hosts` files. Using this module disables
the hosts management function in the `dhcp-server` role.

## Tasks

Tasks are separated in two different parts:

* `tasks/interfaces.yml` manages the network interface.

* `tasks/hosts.yml` manages the hosts file.

## Available variables

Main variables are :

* `staticips.gateway`:        Gateway for the DHCP server.

* `staticips.hosts.hostname`: List. Hostnames of the machines. If set, D-I will
                              autofill the hostname during the installation
                              process.

* `staticips.ip`:             List. IPs of the machines.

* `staticips.mac`:            List. MAC addresses of the machines.
