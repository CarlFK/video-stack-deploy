#!/bin/sh

set -eufx

# hook - if ec.sh exists on the server, get it and run it.
if wget -O - ${url}/ec/ | grep "ec.sh"; then
    wget $url/ec/ec.sh
    chmod u+x ec.sh
    ./ec.sh
fi
