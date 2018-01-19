#!/bin/bash -ex

# serves d-i/foo/preseed, scripts/{early,late}_command.sh, etc.

cd ../roles/tftp-server/files/
python -m SimpleHTTPServer 8007
