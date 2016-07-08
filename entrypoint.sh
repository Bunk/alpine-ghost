#!/bin/bash
set -e

if [[ "$*" == npm*start* ]]; then
    # Explicitly copy all themes separately to ensure the "casper" theme is
    # always available
    baseDir="$GHOST_SOURCE/content"
    echo $baseDir
    for dir in "$baseDir"/*/ "$baseDir"/themes/*/; do
        targetDir="$GHOST_CONTENT/${dir#$baseDir/}"
        mkdir -p "$targetDir"
        if [ -z "$(ls -A "$targetDir")" ]; then
            tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
        fi
    done

    if [ ! -e "$GHOST_CONTENT/config.js" ]; then
        cp "$GHOST_SOURCE/config.js" "$GHOST_CONTENT/config.js"
    fi

    ln -sf "$GHOST_CONTENT/config.js" "$GHOST_SOURCE/config.js"
fi

exec "$@"
