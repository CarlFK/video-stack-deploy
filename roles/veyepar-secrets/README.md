veyepar-secrets
---------------

Copies files from CarlFK's laptop to machines that will be doing veyepar
encoding.

Some of this is a legacy role and should ideally be replaced by use of Ansible Vault.  examples are creds for conference api, video host,
social media, email.

Some of it is asset files that will likely be edited and vetted on a
developer's laptop before being deployed to production.

## Available variables

* `user_name`:                          The username of the main user.
* `org`:                                Name of your organisation. Used in
                                        video files path.
* `show`:                               Name of the event. Used in the video
                                        files path.
* `veyepar_confs`:                      path to the files containing credentials.
* `veyepar_url`:                        URL of the production web site.  used to construct api endpoint to retrieve file names of assets.
* `veyepar_assets`:                     path to asset files on the dev's laptop, typically ~/Videos/veyepar
* `publisher`:                          whose account (youtube) to post videos to

