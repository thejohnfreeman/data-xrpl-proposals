#!/usr/bin/env bash

cat "$@" | awk '
BEGIN {OFS = ","; print "node,ledger,seq,tset"}
$6 == "proposal" {print $7, $8, $9, $10}
' > props.csv
