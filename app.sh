#!/bin/bash

exec env tclsh <<EOF
source lib/ui.tcl

proc do_send command {
  set result [exec env bash -c "source lib/cb.sh && \$command" >@stdout]
  do_recv \$result
}

proc do_recv result {
  set function [lindex \$result 0]
  eval \$function
}

win_logon
EOF
