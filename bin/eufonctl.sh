#!/usr/bin/env bash
SOCAT=socat
display=$1
test -n "$display" || display=$WAYLAND_DISPLAY
test -n "$display" || display=wayland-0

socket_name="${XDG_RUNTIME_DIR}/kiwmi-repl.${display}.socket"

${SOCAT} - unix-connect:$socket_name
