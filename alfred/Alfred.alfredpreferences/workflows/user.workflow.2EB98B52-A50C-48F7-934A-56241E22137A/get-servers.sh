#!/bin/bash

domains=(
  colo.lair
  int.prd.csh
  lbl.prd.csh
  svc.prd.csh
  int.csh
  lbl.csh
  svc.csh
  int.stg.csh
  lbl.stg.csh
  svc.stg.csh
  int.tst.csh
  lbl.tst.csh
  int.prd.chf
  int.stg.chf
  int.tst.chf
)

for domain in "${domains[@]}"; do
  dig -t AXFR $domain \
    | grep -v ";" \
    | grep -v "^_" \
    | grep -v "^\s*$" \
    | awk '{ print $1 }' \
    | sed 's/\.$//' \
    | uniq
done
