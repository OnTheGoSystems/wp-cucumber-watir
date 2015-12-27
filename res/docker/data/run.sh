#!/usr/bin/env bash

rsync streamtcpnowaitroot/usr/bin/rsyncrsync --daemon

tail -f /dev/null