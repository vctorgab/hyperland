#!/bin/bash
# Sync Primary to Clipboard
wl-paste -p --watch wl-copy &
# Sync Clipboard to Primary
wl-paste --watch wl-copy -p &
wait
