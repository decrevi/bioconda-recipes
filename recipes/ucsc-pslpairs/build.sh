#!/bin/bash

set -xe

mkdir -p "$PREFIX/bin"
export MACHTYPE=$(uname -m)
export INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
export CFLAGS="${CFLAGS} -O3 ${LDFLAGS}"
export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include ${LDFLAGS}"
export BINDIR=$(pwd)/bin
export L="${LDFLAGS}"
mkdir -p "$BINDIR"
(cd kent/src/lib && make CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" -j "${CPU_COUNT}")
(cd kent/src/htslib && make CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" -j "${CPU_COUNT}")
(cd kent/src/jkOwnLib && make CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" -j "${CPU_COUNT}")
(cd kent/src/hg/lib && USE_HIC=0 make CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" -j "${CPU_COUNT}")
(cd kent/src/hg/pslPairs && make CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" -j "${CPU_COUNT}")
cp -f bin/pslPairs "$PREFIX/bin"
chmod 0755 "$PREFIX/bin/pslPairs"
