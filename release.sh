#!/bin/bash

ROOT_DIR=`git rev-parse --show-toplevel`
COMMIT_VERSION=`git rev-parse --short HEAD`
BUILD_VERSION=`date +%Y.%m.%d`

cat release/commit.sh.template | sed -e "s/COMMIT_VERSION/${COMMIT_VERSION}/" > .warp/lib/commit.sh
cat release/version.sh.template | sed -e "s/BUILD_VERSION/${BUILD_VERSION}/" > .warp/lib/version.sh

tar cJf warparchive.tar.xz --exclude=".DS_Store" .warp/.
cat warp > dist/warp
cat warparchive.tar.xz >> dist/warp
chmod +x dist/warp
cp dist/warp dist/warp_$BUILD_VERSION

# Add symlink for download purposes
ln -snf "$ROOT_DIR/dist/warp_$BUILD_VERSION" "$ROOT_DIR/release/latest"

echo "New release generated: warp_$BUILD_VERSION"