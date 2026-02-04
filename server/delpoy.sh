#!/bin/bash
set -e

APP_DIR="/var/www/html"
SRC_DIR="$HOME/app"

echo "Starting deployment..."

if [ ! -d "$SRC_DIR" ]; then
  echo "App source directory not found"
  exit 1
fi

sudo rsync -av --delete $SRC_DIR/ $APP_DIR/

echo "Deployment completed successfully"
