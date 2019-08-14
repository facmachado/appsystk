#!/bin/bash

source lib/cb.sh

while read line; do
  test "${line:0:3}" == "cb_" && $line "${@}"
done < <(tclsh <<EOF
source lib/ui.tcl

win_logon

EOF
)
