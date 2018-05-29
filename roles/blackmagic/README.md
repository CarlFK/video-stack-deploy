# blackmagic

Manage and configure the drivers for the Blackmagic SDI capture cards and other
related tools.

Note that since the Blackmagic drivers are not free software, they can't be
freely redistributed.

If you want to use this role, you will have to host them yourself.
Drivers can be found [here][].
Scroll down to "Latest Downloads", and select the most recent Linux
release of "Desktop Video".
Extract it in e.g. `/srv/pxe/bm` on your DHCP server (as that is served
by nginx), and set the URLs to the `.deb`s as global variables.

The DKMS version is visible in the filenames in `/usr/src/blackmagic-*`
in the `desktopvideo` package (e.g. `dpkg-deb -c desktopvideo_*.deb|grep`).

Latest version tested: 10.9.5 -- 2017-09-07
May 11, 2018 testing at Teardown
Blackmagic_Desktop_Video_Linux_10.9.12.tar.gz

[here]: https://www.blackmagicdesign.com/support/family/capture-and-playback

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `blackmagic.desktopvideo`:     URL to the Debian package for the main
                                 Blackmagic driver.

* `blackmagic.desktopvideo_gui`: URL to the Debian package for the Blackmagic
                                 driver GUI, useful for debugging the capture
                                 cards.

* `blackmagic.mediaexpress`:     URL to the Debian package for Blackmagic's
                                 Media Express.

* `blackmagic.dkms_version`:     Blackmagic's DKMS version to install.
