# sreview

Installs and configures encoders for the sreview video reviewing system.

## Tasks

Everything is in the `tasks/main.yml` file.

NOTE: this task has not been tested in production.

## Available variables

* `sreview.dbpw`: password to the SReview database. Should be stored in a
  vault, or passed at initial installation using `ansible-playbook -e
  sreviewdbpw=$VALUE` (ansible role does not write the SReview config
  file unless this variable is defined)
* `sreview.dbhost`: hostname of the machine running the SReview database.
  Defaults to `vittoria.debian.org`.
* `sreview.wwwhostname`: hostname of the machine serving the preview
  files over https. See the SReview documentation on the `vid_prefix`
  configuration parameter for details.
* sreview.preroll: filename of an SVG file containing preroll credits
* sreview.postroll: filename of an SVG file containing postroll credits
* `nfs_server`: the server on which the common state for SReview will be
  stored. That server should have the `nfs-server` role enabled.
