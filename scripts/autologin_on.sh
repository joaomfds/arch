#!/bin/bash

set -e

USER_NAME="joao"
SERVICE_DIR="/etc/systemd/system/getty@tty1.service.d"
OVERRIDE_FILE="$SERVICE_DIR/autologin.conf"

# Create directory for drop-in override if it doesn't exist
if [[ ! -d "$SERVICE_DIR" ]]; then
    sudo mkdir -p "$SERVICE_DIR"
fi

# Write the autologin configuration
sudo tee "$OVERRIDE_FILE" > /dev/null << EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER_NAME --noclear %I \$TERM
EOF

# Reload systemd and restart getty@tty1
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1.service

echo "Autologin enabled for user '$USER_NAME' on tty1."
