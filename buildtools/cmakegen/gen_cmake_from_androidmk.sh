#!/bin/bash

#main(androidmk, cmakelists, androidbuilddir, androidsrcdir)

export ANDROIDMK="$1"
export CMAKELISTSTXT="$2"
export GLOBAL_ANDROIDMK_DIR="$3"
export GLOBAL_ANDROID_SOURCE_DIR="$4"
export SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
make -f $SCRIPTDIR/run.mk
