#!/bin/bash
cd "$(dirname "$0")"
kobopatch || exit 1

KOBO="$(kobo-find -w -f)"
mv KoboRoot.tgz "$KOBO/.kobo/KoboRoot.tgz.tmp"
sync
mv "$KOBO/.kobo/KoboRoot.tgz.tmp" "$KOBO/.kobo/KoboRoot.tgz"
