#!/bin/bash

readonly PIPE='temp.pipe'
test ! -p $PIPE && mkfifo $PIPE

source lib/cb.sh

(
  while read line; do
    if [[ "${line:0:7}" == "__send_" ]]; then
      $line "${@}"
    fi
  done <$PIPE; \
) &

tclsh lib/ui.tcl & PID=$!

while kill -0 $PID; do :; done
rm -f $PIPE
