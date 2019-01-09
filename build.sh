#!/usr/bin/env bash

set -e

mkdir -p build

echo "set base_path $(realpath build)" > build/mirror.list
echo "set nthreads $(nproc)" >> build/mirror.list
echo "set _autoclean 1" >> build/mirror.list
echo "set run_postmirror 0" >> build/mirror.list

ARCHIVE=http://archive.ubuntu.com/ubuntu
COMPONENTS=(main restricted multiverse)
DISTS=(bionic cosmic disco)

for dist in "${DISTS[@]}"
do
    echo "deb $ARCHIVE $dist ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb $ARCHIVE $dist-updates ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb $ARCHIVE $dist-security ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb $ARCHIVE $dist-backports ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb $ARCHIVE $dist-proposed ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb-src $ARCHIVE $dist ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb-src $ARCHIVE $dist-updates ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb-src $ARCHIVE $dist-security ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb-src $ARCHIVE $dist-backports ${COMPONENTS[@]}" >> build/mirror.list
    echo "deb-src $ARCHIVE $dist-proposed ${COMPONENTS[@]}" >> build/mirror.list
done

echo "clean $ARCHIVE" >> build/mirror.list

mkdir -p build/var

apt-mirror build/mirror.list
