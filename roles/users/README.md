# users

Manage user creation, password and SSH access.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `user_name`:             Main user username.

* `user_group`:            Main user group.

* `user_password_crypted`: Main user password in a SHA512 format.

* `public_keys_onsite`:    List. Authorized SSH keys for the main user for
                           machines in the onsite group.

* `public_keys_offsite`:   List. Authorized SSH keys for the main user for
                           machines in the offsite group.

* `public_keys_root`:      List. Authorized SSH keys for root everywhere.

* `ssh_private_key`:       SSH private key to install for the main user.
