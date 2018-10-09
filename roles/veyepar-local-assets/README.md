# veyepar-local-assets

Configure storage for veyepar assets.

This will be applied to the central storage server, and any machines
that are also doing encoding work, over NFS.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are:

* `user_name`:                           Username of the main user.
* `nfs_server`:                          The name of the storage server.
* `org`:                                 Name of your organisation. Used in
                                         video files path.
* `show`:                                Name of the event. Used in the video
                                         files path.
* `room_name`:                           Name of the room that veyepar
                                         should be restricted to. Optional.
