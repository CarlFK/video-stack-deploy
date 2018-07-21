.. _voctomix:

Standalone Voctomix Machine
===========================

The simplest setup that is able to record a talk is a camera connected to a PC
running Voctomix. This can be done as follows:

1. Install Debian Stable on a machine. Make the hostname ``voctomix1``. We
   recommend a minimal install: only the base system and optionally, an SSH
   server. The netinstall image is good for this.

2. Once it is installed, run the following as root:

   .. include:: initial_setup.txt
       :code:

3. Edit ``inventory/group_vars/all`` and change the following:

   .. include:: all_variables.txt
       :code:

4. Run::

    $ ansible-playbook --inventory inventory/hosts --connection local -l voctomix1 site.yml

5. When it completes successfully, restart the machine.

Streaming
---------

Streaming to services such as YouTube is very easy using this setup. It
requires setting up the stream on YouTube and then configuring Voctomix to
connect to this stream.

1. Open YouTube `Live Dashboard`_.

2. Change the *Name* and *Description*, setting the *Category* and *Privacy* as
   required.

3. Note down the *Server URL* and *Stream name/key* (which will be displayed as
   a hidden password until the *Reveal* button is pressed). These will be used
   to configure Voctomix using Ansible.

4. Create an Ansible Vault file for the vault password::

    $ echo "changeme" > /root/.ansible-vault
    $ chmod 600 /root/.ansible-vault

5. Encrypt the URL and stream name in the form ``<URL>/<Stream name>``::

   $ ansible-vault encrypt_string --vault-password-file=/root/.ansible-vault --name=location <URL>/<Stream name>

6. Edit ``inventory/host_vars/voctomix1.yml`` and include the following,
   changing the bitrates as required::

    streaming:
      method: rtmp
      hq_config:
        video_bitrate: 2000 # kbps
        audio_bitrate: 128000 # bps
        keyframe_period: 60 # seconds
      rtmp:
        vaapi: true
        <Output of ansible-vault encrypt_string>

7. Rerun ansible::

    $ ansible-playbook --inventory inventory/hosts --connection local -l voctomix1 site.yml

Once ansible is finished, opening Voctomix and selecting *Stream Live* or
*Stream Loop* will start streaming to YouTube. If you wish to run more than one
room or schedule when your stream goes live, use the *Event* tab and schedule
the stream. Here you can add cameras for additional rooms (one per room).

.. _`Live Dashboard`: https://www.youtube.com/live_dashboard

Notes
-----

Ansible can be run from a laptop or other external source. This makes testing
changes much faster than running it locally. You will require a network that
resolves hostnames to IP addresses correctly. It also requires your SSH key to
be present in the ``authorized_keys`` file for root (this will be the case if
your key is in the ``public_keys_root`` list and you have run ansible before).
In this case run::

    $ ansible-playbook --inventory inventory/hosts -l voctomix1 site.yml

In ``inventory/group_vars/all`` there are two sets of settings which may be of
interest: Blackmagic drivers and Voctomix loops. The Blackmagic drivers
are the proprietary drivers for the HDMI/SDI PCI capture cards that we use. If
you are also using them, uncomment the following and change the URLs to point
to the corresponding package files. ::

    blackmagic:
      desktopvideo: http://example.org/desktopvideo_10.9.5a4_amd64.deb
      desktopvideo_gui: http://example.org/desktopvideo-gui_10.9.5a4_amd64.deb
      mediaexpress: http://example.org/mediaexpress_3.5.3a1_amd64.deb
      dkms_version: 10.9.5a4

The Voctomix loops are shown on the stream when there is no talk happening. In
Voctomix the ``loop_url`` is downloaded and used for the *Stream Loop* button
when the stream is blanked. ``bgloop_url`` is downloaded and used as the
background for Picture-In-Picture mode when the sources do not cover the entire
frame. If you have loops to use, put the URL for them here::

    voctomix:
      loop_url: http://example.org/loop/loop.ts
      bgloop_url: http://example.org/loop/bgloop.ts
