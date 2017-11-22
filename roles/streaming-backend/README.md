# streaming-backend

Install and configure nginx to act as a streaming backend server.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

List of the role's variables. Please follow the following style:

Main variables are :

* `debian_version`:                Codename of the version of Debian used.

* `streaming.backend.data_root`:   nginx data_root.

* `streaming.backend.server_name`: The FQDN of your backend streaming server.

* `streaming.rooms`:               List. The name of the different rooms you are
                                   recording in. This will end up in the URL of
                                   the stream available.
