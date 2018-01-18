# nfs-server

This role installs and configures an NFS server.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `nfs_sever`:           Name of your NFS mount. This variable is used in the
                         NFS mount path.

* `user_name`:           Username of the user who owns the NFS mount used for
                         reviewing.

* `storage_username`:    Username of the user who owns the NFS mount used for
                         storage.

* `storage_userid`:      User ID of the user who owns the NFS mount used for
                         storage.

* `public_keys_storage`: List of SSH public keys of the people who should be
                         able to SSH in the storage box with storage user
                         credentials.
