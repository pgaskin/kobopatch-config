#!/bin/sh
# This script should be sourced

export "PATH=/usr/local/geek1011:$PATH"
for cmd in fbink button_scan; do alias $cmd="LD_LIBRARY_PATH=/usr/local/geek1011 /usr/local/geek1011/$cmd"; done

alias usb_plug_add="echo usb plug add >> /tmp/nickel-hardware-status"
alias usb_plug_remove="echo usb plug remove >> /tmp/nickel-hardware-status"
