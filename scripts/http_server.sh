#!/bin/bash -ex

# serves d-i/foo/preseed, ec/early_command.sh and d-i/late_command.sh

# turn off local cache that runs on the same 8000 port
sudo systemctl stop squid-deb-proxy.service

cd ../roles/tftp-server/files/
python -m SimpleHTTPServer
