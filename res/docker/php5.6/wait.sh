#!/usr/bin/env bash

set -e

while ! nc -z -w 1 $1 $2
do
  sleep 1
done