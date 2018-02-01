Adding a Gateway
================

Adding additional machines to the Voctomix setup usually requires a dedicated
network. This is because the Opsis capture stream uses the hostname of the
Voctomix machine (``voctomix1`` in our example). If the provided network does
hostname DNS resolution correctly, a gateway and dedicated network are not
needed. In this case you can skip this step and `setup the Opsis machine`_
instead.

If it does not, then you must configure a gateway to provide the DNS resolution
to a dedicated network. For more complex setups this is recommended, as the
gateway also provides PXE booting and the ability to automatically configure
machines on initial boot.

1. Install Debian Stable on another machine. Make the hostname ``gw``. If
   you are using a netinstall image, only install the base system and,
   optionally, the SSH server. Do not install Xorg or a desktop environment as
   these are installed by Ansible.

2. If your gateway is to a wireless network, make sure this is configured and
   working

3. Once it is installed, as root, run ::

    $ echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list
    $ apt update
    $ apt install git
    $ apt -t stretch-backports install ansible
    $ git clone https://salsa.debian.org/debconf-video-team/ansible
    $ cd ansible

4. Edit ``inventory/group_vars/all`` and change the following: ::

    public_keys_onsite: [
      <Place your SSH public key here>
    ]

    public_keys_root: [
      <Place your SSH public key here>
    ]

5. Edit ``inventory/host_vars/gw.yml`` and change the following: ::

    eth_local_mac_address: <Your wired local network MAC address>
    eth_uplink_mac_address: <Your uplink MAC address>
    
6. Run ::
     
    $ ansible-playbook --inventory inventory/hosts --connection local -l gw site.yml

5. When it completes successfully, restart the machine.

6. Wire your network.

.. _`setup the Opsis machine`: opsis.html
