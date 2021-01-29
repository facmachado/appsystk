#!/bin/bash

#
#  Copyright (c) 2021 Flavio Augusto (@facmachado)
#
#  License not mandatory. Download it and have fun.
#

src_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
lib_dir="$src_dir/lib"
ui_tk="$lib_dir/ui.tk"
cb_sh="$lib_dir/cb.sh"
tk_exe=$(command -v wish)

exec "$tk_exe" <<EOF
proc call {shcmd args} {
  return [exec bash -c "source '$cb_sh' && \$shcmd \$args"]
}

source "$ui_tk"
EOF
