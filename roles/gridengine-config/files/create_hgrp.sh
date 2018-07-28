#!/bin/sh

set -e

directory=$(mktemp -d)

list=""

while [ ! -z $1 ]
do
	list="$list $1"
	shift
done

cat > "${directory}/hgrp" <<EOF
group_name @allhosts
hostlist $list
EOF

qconf -Ahgrp "${directory}/hgrp"
