#!/bin/bash

URL="http://localhost"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$STATUS" -ne 200 ]; then
  echo "Health check failed with status code $STATUS"
  exit 1
else
  echo "Health check passed"
fi
