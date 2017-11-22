# apt

Manage and configure apt.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `debian_source`:      The Debian source you want to use.

* `debian_version`:     The Debian codename you want to use.

* `apt_proxy`:          Boolean variable. If set to false, it will remove the
                        apt proxy D-I set one.

* `update_apt_sources`: Boolean value. If set to false, this role won't touch
                        your apt source.list file.

* `enable_sid`:         Boolean value. Enable sid in the apt sources.

* `enable_oldstable`:   Boolean value. Enable oldstable in the apt sources.
