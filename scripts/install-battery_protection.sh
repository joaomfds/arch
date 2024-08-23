#!/bin/bash

sudo cp battery-charge-threshold.service /etc/systemd/system/

sudo systemctl enable battery-charge-threshold


