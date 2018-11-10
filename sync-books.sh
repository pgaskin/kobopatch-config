#!/bin/bash

KOBO=""
while [[ ! -d "$KOBO" ]]; do
    KOBO="$(findmnt --raw --noheadings --first-only --output TARGET LABEL=KOBOeReader)"
    sleep .5
done

kepubify --update --output "$KOBO/kepubify" "$HOME/Documents/Books/Books/"
