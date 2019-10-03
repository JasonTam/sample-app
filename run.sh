#!/bin/sh

echo $(date --utc +%FT%TZ)

gunicorn app.main:app -b 0.0.0.0:5000
