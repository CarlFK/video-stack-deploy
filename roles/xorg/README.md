# xorg

Manage the X server and other related GUI applications, like IRC.

## Tasks

The tasks are divided this way:

* `tasks/'konversation.yml`: Manages IRC connection via Konversation.

* `tasks/'lightdm.yml:` Manages LightDM.

* `tasks/'packages.yml`: Installs video-related packges.

* `tasks/'scripts.yml`: Configures useful scripts.

* `tasks/'xfce4.yml`: Configures XFCE.

* `tasks/'xorg.yml`: Configures Xorg server.

## Available variables

Main variables are :

* `user_name`:           The username of the main user.

* `autologin`:           Boolean. If false, the LightDM autologin is turned off.

* `irc.autostart`:       Start the IRC client on login.

* `irc.network`:         Name of the IRC server to connect to.

* `irc.server`:          Domain name of the IRC server to connect to.

* `irc.ssl_port`:        Integer. SSL port of the IRC server to connect to.

* `irc.global_channels`: List. Channels to connect to.

* `irc_nick`:            IRC nickname.
