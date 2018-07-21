Adding a Gateway
================

Adding additional machines to the Voctomix setup usually requires a dedicated
network. This is because the Opsis capture stream is directed to the hostname of
the Voctomix machine (``voctomix1`` in our example). If the ``voctomix1``
hostname is available in the local DNS (e.g. from its DHCP lease), then this
should work and you can skip this step and setup the :ref:`Opsis machine
<opsis>` instead.
If not, we would recommend using a gateway and a dedicated network. This is
recommended for more complex setups, as the gateway also provides PXE booting
and the ability to automatically configure machines on initial boot.

1. Install Debian Stable on another machine in the same manner you installed
   the :ref:`Voctomix <voctomix>` machine. Make the hostname ``gw``.

2. If your gateway is to a wireless network, make sure this is configured and
   working

3. Once it is installed, run the following as root:

   .. include:: initial_setup.txt
       :code:

4. Edit ``inventory/group_vars/all`` and change the following:

   .. include:: all_variables.txt
       :code:

5. Edit ``inventory/host_vars/gw.yml`` and change the following::

    eth_local_mac_address: <Your wired local network MAC address>
    eth_uplink_mac_address: <Your uplink MAC address>

6. Run::

    $ ansible-playbook --inventory inventory/hosts --connection local -l gw site.yml

7. When it completes successfully, restart the machine.

8. Connect the gateway to the Voctomix machine over a gigabit network and
   restart the Voctomix machine.
