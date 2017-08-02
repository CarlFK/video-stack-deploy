#!/bin/sh

set -e

directory=$(mktemp -d)

domainname=$1
shift

list=""

while [ ! -z $1 ]
do
	list="$list $1.$domainname"
	shift
done

cat > "${directory}/hgrp" <<EOF
group_name @allhosts
hostlist $list
EOF

qconf -Ahgrp "${directory}/hgrp"
