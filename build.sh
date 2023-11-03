#!/bin/bash

OUTDIR=build

TARGETPREFIXLIST=(x86_64-linux-gnu i686-linux-musl mipseb-linux-musl mipsel-linux-musl arm-linux-musleabi aarch64-linux-musl mips64eb-linux-musl mips64el-linux-musl)
TARGETNAMELIST=(  x86_64           i686            mips              mips              arm                aarch64            mips64              mips64             )

mkdir -p $OUTDIR

for i in "${!TARGETNAMELIST[@]}"; do
    make ARCH=${TARGETNAMELIST[i]} CROSS_COMPILE=${TARGETPREFIXLIST[i]}-

    # copy the unstripped version if the stripped version doesn't exist
    mv busybox $OUTDIR/busybox.${TARGETPREFIXLIST[i]} \
        || mv busybox_unstripped $OUTDIR/busybox.${TARGETPREFIXLIST[i]}

    # busybox doesn't have any way to configure build artifact location,
    # so we need to clean up when we're done in case the next arch's build
    # fails. also we need to build 1-by-1
    make clean
done
