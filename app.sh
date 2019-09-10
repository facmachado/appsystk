#!/bin/bash

exec env tclsh <<EOF
source lib/ui.tcl

proc do_exit {} {
  exit 0
}

proc do_send command {
  set result [exec env bash -c "source lib/cb.sh && \$command"]
  do_recv \$result
}

proc do_recv result {
  set function [string range [lindex \$result 0] 7 9999]
  eval \$function
}

win_logon
EOF
