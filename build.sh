#!/usr/bin/env bash

# Ubuntu default US mirror
MIRROR=rsync://us.archive.ubuntu.com/ubuntu/

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
  --verbose
  "${MIRROR}"
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

