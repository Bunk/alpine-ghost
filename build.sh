#!/usr/bin/env sh
set -ex

apk upgrade
apk update

mkdir -p "$GHOST_CONTENT"

# TODO: Remove bash -- need to rewrite the entrypoint to be POSIX-compliant
apk --no-cache add tar tini bash su-exec
apk --no-cache add --virtual devs gcc make python wget unzip ca-certificates

# Download Ghost from the deployed archives
wget -O ghost.zip "https://github.com/TryGhost/Ghost/releases/download/${GHOST_VERSION}/Ghost-${GHOST_VERSION}.zip"
unzip ghost.zip
rm ghost.zip
npm install --production

# Cleanup
npm cache clean
apk del devs
rm -rf /tmp/*
