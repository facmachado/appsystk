#!/bin/bash

function __send_chpwd() {
  echo "$@"
}

function __send_logon() {
  echo "__recv_win_read_code" "$@"
}

function __send_read_code() {
  echo "__recv_win_main" "$@"
}
