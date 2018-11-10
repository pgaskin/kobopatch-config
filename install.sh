#!/bin/bash

cd "$(dirname "$0")"
kobopatch || exit 1

KOBO=""
while [[ ! -d "$KOBO" ]]; do
    KOBO="$(findmnt --raw --noheadings --first-only --output TARGET LABEL=KOBOeReader)"
    sleep .5
done

mv KoboRoot.tgz "$KOBO/.kobo/KoboRoot.tgz.tmp"
sync
mv "$KOBO/.kobo/KoboRoot.tgz.tmp" "$KOBO/.kobo/KoboRoot.tgz"
