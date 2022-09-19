#!/usr/bin/env bash

set -ex

mkdir -p build

# Two stage sync, for safety
RSYNC_ARGS=(
  --recursive
  --times
  --links
  --safe-links
  --hard-links
  --stats
  rsync://archive.ubuntu.com/ubuntu/
  build/
)

rsync \
  --exclude "Packages*" \
  --exclude "Sources*" \
  --exclude "Release*" \
  --exclude "InRelease" \
  "${RSYNC_ARGS[@]}"

rsync \
  --delete \
  --delete-after \
  "${RSYNC_ARGS[@]}"

