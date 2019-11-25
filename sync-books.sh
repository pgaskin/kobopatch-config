#!/bin/bash
kepubify --update --output "$(kobo-find -w -f)/kepubify" "$HOME/Documents/Books/Books/"
seriesmeta
covergen -a 1.5
