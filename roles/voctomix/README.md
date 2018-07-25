# voctomix

Manage and configure the voctomix live editing software.

## Tasks

The tasks are divided this way:

* `tasks/blackmagic.yml`: Manage systemd unit files for the blackmagic capture.

* `tasks/rtmp.yml`: Manage RTMP streaming to the streaming backend machine.

* `tasks/scripts.yml`: Manage useful scripts for the video director.

* `tasks/tallylight.yml`: Manage the tally lights.

* `tasks/video_disk.yml`: Manage partitions to record to.

* `tasks/voctomix.yml`: Install and configure voctomix.

## Available variables

Main variables are :

* `user_name`:                           Main user username.

* `storage_username`:                    Storage user username.

* `debian_version`:                      Version of Debian, when using Debian.

* `org`:                                 Name of your organisation. Used in
                                         video files path.

* `show`:                                Name of the event. Used in the video
                                         files path.

* `room_name`:                           Name of the room where you are
                                         recording. Used in the video file path.

* `frequency`:                           The local frequency setting (50 or 60Hz).
                                         Used to derive sensible defaults.

* `sources`:                             List. Name of the different sources you
                                         want voctomix to use.

* `voctomix.display_system`:             Rendering API (OpenGl, Vulkan, etc.) to
                                         use.

* `voctomix.framerate`:                  Integer. Number of frames per second to
                                         record at.  Defaults to `frequency/2`

* `voctomix.loop_url`:                   URL of the sponsor loop .ts file.

* `voctomix.bgloop_url`:                   URL of the background loop .ts file.

* `streaming.method`:                    Streaming method used. At the moment,
                                         only `none` and `rtmp` values are
                                         supported.

* `streaming.hq_config.video_bitrate`:   Integer. Video streaming bitrate in
                                         kbps.

* `streaming.hq_config.audio_bitrate`:   Integer. Audio streaming bitratein in
                                         bps.

* `streaming.hq_config.keyframe_period`: Integer. Seconds between the creation
                                         of key frames.

* `streaming.rtmp.location`:             RTMP URL to the streaming endpoint.
                                         For YouTube, this would be:
                                         `rtmp://a.rtmp.youtube.com/live2/x/SUPER_SECRET_KEY app=live2`

* `streaming.rtmp.vaapi`:                Boolean. Use HW-accelerated x264
                                         encoder.

* `blackmagic_default_mode`:             Default value for `blackmagic_sources.*.mode`,
                                         computed from `framerate`.

* `blackmagic_sources.*`:                Array. Uses the `card`, `connection`,
                                         `audio` and `mode` parameters as
                                         described below. The exact syntax is
                                         can be found in the defaults file.

* `blackmagic_sources.card`:             Integer. Number of the card.

* `blackmagic_sources.connection`:       Video connection type. Currently
                                         supports `SDI` and `HDMI`.

* `blackmagic_sources.audio`:            Boolean. If true, audio capture is
                                         enabled on the card.

* `blackmagic_sources.mode`:             Integer. Video mode of the capture
                                         card. You can get a list of the
                                         different modes by running
                                         `gst-inspect-1.0 decklinkvideosrc`.
                                         Defaults to `blackmagic_default_mode`.

* `rsync_excludes`:                      List. Paths to exclude during the rsync
                                         copy of the video files.

* `rsync_sshopts`:                       Rsync SSH options.

* `video_disk`:                          Partition to create and mount on
                                         `/srv/video`.

* `voctolights.*`:                       Array. Uses the `camera`, `port` and
                                         `host` parameters as described below.
                                         The exact syntax can be found in the
                                         defaults file.

* `voctolights.camera`:                  Name of the camera sources, as
                                         described in the `sources` variable.

* `voctolights.port`:                    Serial port to attach the tally light
                                         to.

* `voctolights.host`:                    Hostname of the machine where the tally
                                         light is on.
