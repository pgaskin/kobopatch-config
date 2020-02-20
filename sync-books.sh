#!/bin/bash
kepubify --update --output "$(kobo-find -w -f)/kepubify/Books_converted/" "$HOME/Documents/Books/Books/"
seriesmeta
covergen -a 1.5
dictutil install -lgt -nGOTDict "$HOME/Documents/Books/Dictionaries/gotdict.zip"
dictutil install -lox -nOxford "$HOME/Documents/Books/Dictionaries/oxford.zip"
