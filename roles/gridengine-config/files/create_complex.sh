#!/bin/bash

set -e

dirname=$(mktemp -d)

qconf -sc > ${dirname}/complex

name=$1
shift

echo "$name $name $@" >> ${dirname}/complex

qconf -Mc ${dirname}/complex

rm -rf ${dirname}
