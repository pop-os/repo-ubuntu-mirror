#!/usr/bin/env bash

# The archive to mirror
ARCHIVE=archive.ubuntu.com/ubuntu
# The components to mirror
COMPONENTS=(main restricted universe multiverse)
# Distributions to mirror
DISTS=(bionic cosmic disco)
# Repos to mirror
REPOS=("" "-security" "-updates" "-backports" "-proposed")
# Architectures to mirror
ARCHS=(amd64 i386 src)

set -e

mkdir -p build

echo "set base_path $(realpath build)" > build/mirror.list
echo "set nthreads 64" >> build/mirror.list
echo "set _autoclean 1" >> build/mirror.list
echo "set run_postmirror 1" >> build/mirror.list

echo "#!/usr/bin/env bash" > build/var/postmirror.sh
echo "set -ex" >> build/var/postmirror.sh

for dist in "${DISTS[@]}"
do
    for repo in "${REPOS[@]}"
    do
        for arch in "${ARCHS[@]}"
        do
            echo "deb-${arch} http://${ARCHIVE} ${dist}${repo} ${COMPONENTS[@]}" >> build/mirror.list
        done
        for component in "${COMPONENTS[@]}"
        do
            echo rsync \
                --recursive \
                --times \
                --links \
                --hard-links \
                --delete \
                --delete-after \
                --delete-missing-args \
                "'rsync://${ARCHIVE}/dists/${dist}${repo}/${component}/cnf'" \
                "'${ARCHIVE}/dists/${dist}${repo}/${component}/'" \
                >> build/var/postmirror.sh
        done
    done
done

echo "clean $ARCHIVE" >> build/mirror.list

mkdir -p build/var

./apt-mirror/apt-mirror build/mirror.list
