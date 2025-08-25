#!/bin/bash
if pgrep -x "nwg-drawer" > /dev/null; then
    pkill -f nwg-drawer  # closes the drawer if open
else
    nwg-drawer &         # opens the drawer if closed
fi
