#!/bin/bash
set -e

echo "Restarting Nginx..."
sudo systemctl restart nginx
sudo systemctl status nginx --no-pager
