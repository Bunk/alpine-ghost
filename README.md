# alpine-ghost
Ghost image running in Alpine Linux on Node 6

This image will copy any themes found in the Ghost image to the `$GHOST_CONTENT/themes` directory.  This allows a derived image to either override, or supply its own themes.