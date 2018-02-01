Adding an Opsis Machine
=======================

The next step is to add a Numato Opsis board and capture PC for capturing
presentations. The hardware setup for this can be found `here`_. The basic
layout is the presenter's laptop is connected to the Opsis HDMI input, the Opsis
HDMI output is connected to the projector and the Opsis USB capture is connected
to a machine sitting next to it. This is connected to the Voctomix machine over
a wired network.

Communicating with the Opsis board happens over USB serial. Flashing an Opsis
with new firmware is described in the `official documentation`. For details
about how to access the Opsis board to troubleshoot or change its setup, look
at our `general documentation` on the subject.

1. Install Debian Stable on another machine. Make the hostname ``opsis1``. If
   you are using a netinstall image, only install the base system and,
   optionally, the SSH server. Do not install Xorg or a desktop environment as
   these are installed by Ansible.

2. Once it is installed, as root, run::

    $ echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list
    $ apt update
    $ apt install git
    $ apt -t stretch-backports install ansible
    $ git clone https://salsa.debian.org/debconf-video-team/ansible
    $ cd ansible

3. Edit ``inventory/group_vars/all`` and change the following::

    public_keys_onsite: [
      <Place your SSH public key here>
    ]

    public_keys_root: [
      <Place your SSH public key here>
    ]

4. Run::

    $ ansible-playbook --inventory inventory/hosts --connection local -l opsis1 site.yml

5. When it completes successfully, restart the machine.

.. _`here`: https://debconf-video-team.pages.debian.net/docs/hardware.html#laptop-output-capture
.. _`official documentation`: https://hdmi2usb.tv/firmware/#flashing-prebuilt-firmware
.. _`general documentation`: https://debconf-video-team.pages.debian.net/docs/opsis.html
