#!/usr/bin/env bash

cat "$@" | awk '
BEGIN {OFS=","; print "tset,txn,fee"}
$5 == "tset" {print $6, $7, $8}
' > tsets.csv
