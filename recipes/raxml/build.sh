#!/bin/bash

set -exo pipefail

case $(uname) in
Darwin) SUF=.mac ;;
Linux) SUF=.gcc ;;
*)
  echo "Unknown architecture"
  exit 1
  ;;
esac

ARCH=$(uname -m)

mkdir -p "$PREFIX"/bin

for PTHREADS in "" .PTHREADS; do
  for OPT in "" .SSE3 .AVX2; do

    if [[ "${ARCH}" == "aarch64" && "${OPT}" == ".AVX2" ]]; then
      continue
    fi

    if [[ ${ARCH} == "arm64" && ("${OPT}" == ".AVX2" || "${OPT}" == ".SSE3" || "${PTHREADS}" == ".PTHREADS") ]]; then
      continue
    fi

    echo "######## Building Flags opt=$OPT pthread=$PTHREADS os=$SUF ######"
    MAKEFILE=Makefile${OPT}${PTHREADS}
    if [ -e ${MAKEFILE}${SUF} ]; then
      MAKEFILE=${MAKEFILE}$SUF
    else
      MAKEFILE=${MAKEFILE}.gcc
    fi
    make -f ${MAKEFILE} CC=$CC
    mv raxmlHPC* "$PREFIX"/bin
    make -f ${MAKEFILE} clean
  done
done
