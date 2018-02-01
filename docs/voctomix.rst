Standalone Voctomix Machine
===========================

The simplest setup that is able to record a talk is a camera connected to a PC
running Voctomix. This can be done as follows:

1. Install Debian Stable on another machine. Make the hostname ``voctomix1``. We
   recommend a minimal install: onlly the base system and optionally, an SSH
   server. The netinstall image is good for this.

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

    $ ansible-playbook --inventory inventory/hosts --connection local -l voctomix1 site.yml

5. When it completes successfully, restart the machine.

Notes
-----

Ansible can be run from a laptop or other external source. This makes testing
changes much faster. You will require a network that resolves hostnames to IP
addresses correctly. It also requires your SSH key to be present in the
``authorized_keys`` file for root (this will be the case if your key is in the
``public_keys_root`` list and you have run ansible before). In this case run::

    $ ansible-playbook --inventory inventory/hosts -l voctomix1 site.yml

In inventory/group_vars/all there are two sets of settings that may be of
interest, namely Blackmagic drivers and Voctomix loops. The Blackmagic drivers
are the proprietary drivers for the HDMI/SDI PCI capture cards that we use. If
you are also using them, uncomment the following and change the URLs to point
to the corresponding package files. ::

    blackmagic:
      desktopvideo: http://example.org/desktopvideo_10.9.5a4_amd64.deb
      desktopvideo_gui: http://example.org/desktopvideo-gui_10.9.5a4_amd64.deb
      mediaexpress: http://example.org/mediaexpress_3.5.3a1_amd64.deb
      dkms_version: 10.9.5a4

The Voctomix loops are shown on the stream when there is no talk happening. In
Voctomix the ``loop_url`` is downloaded and used for the Stream Loop button
when the stream is blanked. ``bgloop_url`` is downloaded and used as the
background for Picture-In-Picture mode when the sources do not cover the entire
frame. If you have loops to use, put the URL for them here::

    voctomix:
      loop_url: http://example.org/loop/loop.ts
      bgloop_url: http://example.org/loop/bgloop.ts
