#!/bin/bash

AUTHOR="Anon"
OS="None"
IMGNAME="base-java"
VERSION="1.0"
CMD="/usr/bin/java"
RELEASEVER="35"

TMPIMG=$(buildah from scratch)

echo "Created TMPIMG named $TMPIMG"
echo "Adding information to $TMPIMG"
printf "\tImage Name: %s\n", $IMGNAME
printf "\tVersion: %s\n", $VERSION
printf "\tCMD: %s\n", $CMD

buildah config --author="Anon" --env PATH=$PATH --label Name=$IMGNAME --label Version=$VERSION --cmd $CMD $TMPIMG

INSTALLROOT=$(buildah mount $TMPIMG)

dnf install \
	--installroot $INSTALLROOT \
	--releasever $RELEASEVER \
	--setopt install_weak_deps=false \
	--setopt max_parallel_downloads=20 \
	-y --nogpg \
	java-11-openjdk

dnf clean all --installroot $INSTALLROOT --releasever $RELEASEVER

buildah commit --squash $TMPIMG cr.local/$IMGNAME:$VERSION

# buildah push --format oci $IMGNAME oci-archive:img:$NAME

buildah rm $TMPIMG
