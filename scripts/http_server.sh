#!/bin/bash -ex

# serves d-i/foo/preseed, ec/early_command.sh and d-i/late_command.sh

cd ../roles/tftp-server/files/
python -m SimpleHTTPServer 8007
