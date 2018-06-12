# users

Manage user creation, password and SSH access.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `user_name`:             Main user username.

* `user_group`:            Main user group.

* `user_password_crypted`: Main user password in a SHA512 format. To generate,
                           you can use `mkpasswd -m sha-512` from the `whois`
                           package.

* `public_keys_onsite`:    List. Authorized SSH keys for the main user for
                           machines in the onsite group.

* `public_keys_offsite`:   List. Authorized SSH keys for the main user for
                           machines in the offsite group.

* `public_keys_root`:      List. Authorized SSH keys for root everywhere.

* `ssh_private_key`:       ed25519 SSH private key to install for the main user.

* `time_zone`:             Timezone using the tzdata format.
