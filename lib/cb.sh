#!/bin/bash

function __send_chpwd() {
  echo "$@"
}

function __send_logon() {
  echo "$@"
  echo "__recv_win_read_code" >$PIPE
}

function __send_read_code() {
  echo "$@"
  echo "__recv_win_main" >$PIPE
}
