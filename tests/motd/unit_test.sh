#!/bin/sh

# This is a unit test for the motd

# Test if the motd is set correctly
diff /etc/motd tests/motd/good_motd.txt && exit || echo "motd not set correctly" && exit 1

# Test if the 3 scripts we use for the motd fail
p="/etc/profile.d"
sh $p/showcpu.sh >/dev/null && exit || echo "error in script $p/showcpu.sh" && exit 1
sh $p/showrelease.sh >/dev/null && exit || echo "error in script $p/showrelease.sh" && exit 1
sh $p/uptime.sh >/dev/null && exit || echo "error in script $p/uptime.sh" && exit 1
