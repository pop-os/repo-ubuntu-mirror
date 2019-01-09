#!/usr/bin/env bash

set -ex

function install_debrep {
	LATEST=$(git ls-remote https://github.com/pop-os/debrepbuild | grep HEAD | cut -c-7)

	if type debrep; then
		CURRENT=$(debrep --version | cut -d' ' -f5 | cut -c2- | cut -c-7)
	    if [ ! $CURRENT ] || [ $CURRENT != $LATEST ]; then
	    	INSTALL=1
	    fi
	else
		INSTALL=1
	fi

	if [ $INSTALL ]; then
		cargo install --git https://github.com/pop-os/debrepbuild --force
	fi
}

function copy_suites {
	rsync -avz suites build/
}

install_debrep
copy_suites

cd build
debrep build
cd ..
