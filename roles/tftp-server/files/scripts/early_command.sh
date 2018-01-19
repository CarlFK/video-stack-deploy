#!/bin/sh

set -eufx

# hook - if ec.sh exists on the server, get it and run it.
# This allows local debugging hacks to be in a file that isn't clobbered by
# ansible, but is locally hackable.

if wget -O - ${url}/scripts/ | grep "ec.sh"; then
    wget $url/scripts/ec.sh
    chmod u+x ec.sh
    ./ec.sh
fi
