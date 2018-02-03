Adding an Opsis Machine
=======================

The next step is to add a Numato Opsis board and capture PC for capturing
presentations. The hardware setup for this can be found `here`_. The basic
layout is:

* The presenter's laptop connects to the Opsis HDMI input
* The Opsis HDMI output connects to the projector
* The Opsis USB capture connects to a capture PC sitting next to it.
* The capture PC is connected to the Voctomix machine over a gigabit ethernet
  network.

The Opsis is configured through a USB serial console. Flashing an Opsis with new
firmware is described in the `official documentation`_. For details on accessing
the Opsis board to troubleshoot or change its setup, look at our
`general documentation`_ on the subject.

1. Install Debian Stable on another machine in the same manner you installed
   the `Voctomix`_ machine. Make the hostname ``opsis1``.

2. Once it is installed, run the following as root:

   .. include:: initial_setup.txt
       :code:

3. Edit ``inventory/group_vars/all`` and change the following:

   .. include:: all_variables.txt
       :code:

4. Run::

    $ ansible-playbook --inventory inventory/hosts --connection local -l opsis1 site.yml

5. When it completes successfully, restart the machine.

.. _`here`: https://debconf-video-team.pages.debian.net/docs/hardware.html#laptop-output-capture
.. _`official documentation`: https://hdmi2usb.tv/firmware/#flashing-prebuilt-firmware
.. _`general documentation`: https://debconf-video-team.pages.debian.net/docs/opsis.html
.. _`Voctomix`: voctomix.html
