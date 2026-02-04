#!/bin/bash

echo "Running bootstrap after reboot" >> /var/log/bootstrap.log

/home/ubuntu/scripts/restart.sh
/home/ubuntu/scripts/health.sh
