#!/bin/bash
set -e

if [[ "$*" == npm*start* ]]; then
    baseDir="$GHOST_SOURCE/content"

    for dir in "$baseDir"/*/ "$baseDir"/themes/*/; do
        targetDir="$GHOST_CONTENT/${dir#$baseDir/}"
        mkdir -p "$targetDir"
        if [ -z "$(ls -A "$targetDir")" ]; then
            tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
        fi
    done

    # Prefer a configuration to be built into the image under
    if [ ! -e "$GHOST_SOURCE/config.js" ]; then
        # There isn't a hard-wired configuration
        # Let's use the one supplied as an override

        if [ ! -e "$GHOST_CONTENT/config.js" ]; then
            # There isn't a supplied override.
            # Let's convert the example, replacing for use with env vars
            sed -r '
                s/127\.0\.0\.1/0.0.0.0/g;
                s!path.join\(__dirname, (.)/content!path.join(process.env.GHOST_CONTENT, \1!g;
            ' "$GHOST_SOURCE/config.example.js" > "$GHOST_CONTENT/config.js"
        fi

        ln -sf "$GHOST_CONTENT/config.js" "$GHOST_SOURCE/config.js"
    fi

    # Supply ownership of the user content directory
    chown -R app "$GHOST_CONTENT"
    # Supply ownership of the source content for production-mode
    chown -R app "$GHOST_SOURCE/content"

    set -- su-exec app "$@"
fi

exec "$@"
