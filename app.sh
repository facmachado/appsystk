#!/bin/bash

source lib/cb.sh

while read line; do
  test "${line:0:5}" == "__cb_" && $line "${@}"
done < <(tclsh <<EOF
source lib/ui.tcl

win_logon

EOF
)
