Advanced Usage
==============

This basic setup will work for a small conference. It is possible to add more
rooms by including more Voctomix and Opsis machines in their respective groups.
These machines need corresponding ``inventory/host_vars/`` files. These need to
be changed to reflect the details of the room each machine is in. Entries also
need to be added to the ``staticips.hosts`` dictionary in
``inventory/group_vars/all``.

For large setups, using PXE booting to configure machines, you should create a
git repository with your copy of ``inventory/``. See `our config repo`_ for an
example of how to set this up. It requires setting ``inventory_repo`` and
``inventory/group_vars/all``. ``inventory_branch`` defaults to master, but this
can also be set.

``staticips.hosts`` can include a MAC address for each host. This will
automatically assign the machine a hostname when PXE booting and will ensure
that it has a static IP from the gateway.

.. _`our config repo`: https://salsa.debian.org/debconf-video-team/ansible-inventory
