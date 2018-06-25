#!/bin/sh

# Sample ~/.ssh/config:
# Host logz-dev
# Hostname 172.99.67.54
# User atat

ssh -L 24224:localhost:24224 logz-dev
