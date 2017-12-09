#!/bin/bash -ex

# Mostly to confirm the basics is installed and setup properly.
# test1.sh expects git checkouts, test2 installed on $PATH

voctocore -i test1.ini &
sleep 5
voctogui &
voctomix-ingest &
sleep 1
voctomix-ingest --port 10001  --video-attribs "pattern=circular horizontal-speed=2" &
voctomix-record-timestamp &
voctomix-generate-cut-list
