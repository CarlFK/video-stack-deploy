The Physical Layout
===================

The hardware we use is described in our `general documentation`_.

The Ansible configuration sets up 9 groups of machines:

DHCP and TFTP Server
    This is the gateway between the internet and the video team network. It
    enables PXE booting the other local machines and configuring them using
    Ansible automatically.

Opsis
    These are the PCs that are connected to the Numato Opsis boards and capture
    the presenter's laptop output for streaming to Voctomix.

Voctomix
    These are the PCs that live-mix the video from the cameras and opsis capture
    for recording to disk and live streaming to the internet.

NFS Server
    This provides an NFS share for SReview, as it requires a common file system
    between nodes.

Grid Engine Master
    This is the master node controlling the grid engine that manages our
    encoding machines.

Encoder
    These are the encoding nodes that are added to the grid engine and encode
    the recorded talks for review and upload.

Streaming Back-end
    This receives the RTMP streams from the rooms, saves these to disk and
    presents this over HTTP using DASH in a variety of formats.

Streaming Front-end
    These machines are caching proxies in front of the streaming back-end,
    geographically distributed around the world. Users probably connect to
    these, not the back-end, when they exist.

Review
    The machines that will host and manage `SReview`_, which is our review
    system for talks after they are recorded.

Using all 9 groups in a full-blown conference gets complicated very quickly.
For this reason, we will go through two much simpler streaming and recording
examples here:

1. A single Voctomix machine that stands alone.
2. Voctomix and Opsis machines with a gateway to the outside world.

.. _`general documentation`: https://debconf-video-team.pages.debian.net/docs/hardware.html
.. _SReview: https://debconf-video-team.pages.debian.net/docs/review.html
