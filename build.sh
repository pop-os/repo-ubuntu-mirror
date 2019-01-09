#!/usr/bin/env bash

set -e

mkdir -p build

echo "set base_path $(realpath build)" > build/mirror.list
echo "set nthreads $(nproc)" >> build/mirror.list
echo "set _autoclean 1" >> build/mirror.list
echo "set run_postmirror 0" >> build/mirror.list

for dist in bionic cosmic disco
do
    echo "deb http://archive.ubuntu.com/ubuntu $dist main" >> build/mirror.list
    echo "deb http://archive.ubuntu.com/ubuntu $dist-updates main" >> build/mirror.list
    echo "deb http://archive.ubuntu.com/ubuntu $dist-security main" >> build/mirror.list
    echo "deb http://archive.ubuntu.com/ubuntu $dist-backports main" >> build/mirror.list
    echo "deb http://archive.ubuntu.com/ubuntu $dist-proposed main" >> build/mirror.list
    echo "deb-src http://archive.ubuntu.com/ubuntu $dist main" >> build/mirror.list
    echo "deb-src http://archive.ubuntu.com/ubuntu $dist-updates main" >> build/mirror.list
    echo "deb-src http://archive.ubuntu.com/ubuntu $dist-security main" >> build/mirror.list
    echo "deb-src http://archive.ubuntu.com/ubuntu $dist-backports main" >> build/mirror.list
    echo "deb-src http://archive.ubuntu.com/ubuntu $dist-proposed main" >> build/mirror.list
done

echo "clean http://archive.ubuntu.com/ubuntu" >> build/mirror.list

mkdir -p build/var

apt-mirror build/mirror.list
