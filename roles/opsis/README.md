# opsis

Configures a machine as an Opsis capture PC.

Also supports Black Magic Web Presenter devices, that present a similar
v4l USB device.

## Tasks

Tasks are separated in two different parts:

* `tasks/opsis.yml` manages the tools to setup up and connect to the opsis.

* `tasks/bmusb.yml` installs a udev rule to grant permissions to Blackmagic Web
   Presenter USB device.

* `tasks/hdmi2usbmond.yml` manages the HDMI2USB monitoring tools.

## Available variables

List of the role's variables. Please follow the following style:

Main variables are :

* `serial_terminal`: List. Installs serial terminal packages that are in Debian.
                     The first one listed will be used for the `opsis` command
                     used to connect to the opsis board.

* `voctomix.host`:   Hostname or IP of the voctomix machine.

* `voctomix.port`:   Incoming port the voctomix machine listens to.

* `alsa_device`:     ALSA device used for USB audio capture.

* `audio_delay`:     Delay in ms for the audio capture.

* `video_delay`:     Delay in ms for the video capture.
