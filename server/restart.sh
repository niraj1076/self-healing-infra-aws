#!/bin/bash
set -e

echo "Restarting Nginx..."
sudo service restart nginx
sudo service status nginx --no-pager
