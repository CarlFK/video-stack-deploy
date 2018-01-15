# system-software

Install useful packages and enable some systemd logs.

## Tasks

Tasks are separated in two different parts:

* `tasks/packages.yml` installs packages.

* `tasks/systemd.yml` manages some systemd logs.

## Available variables

Main variables are:

* `firmware_packages`: A list of firmware packages to install.
