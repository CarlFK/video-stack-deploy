# blackmagic

Manage and configure the drivers for the Blackmagic SDI capture cards and other
related tools.

Note that since the Blackmagic drivers are not free software, they can't be
freely redistributed.

If you want to use this role, you will have to host them yourself. Drivers can
be found [here][].

Latest version tested: 10.9.5 -- 2017-07-20

[here]: https://www.blackmagicdesign.com/support/family/capture-and-playback

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `blackmagic.desktopvideo`: The URL to the .deb for the main Blackmagic driver.
* `blackmagic.desktopvideo_gui`: The URL to the .deb for the Blackmagic driver
                                 GUI, useful for debugging the capture cards.
* `blackmagic.mediaexpress`: The URL to the .deb for Blackmagic's Media Express.
* `blackmagic.dkms_version`: Blackmagic's DKMS version to install.
