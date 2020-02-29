#!/bin/bash
dicthtml I -lgt -nGOTDict "$HOME/Documents/Books/.kobodict/gotdict.zip"
dicthtml I -lox -nOxford "$HOME/Documents/Books/.kobodict/oxford.zip"
kepubify -u -o"$(kobo-find -w -f)/kepubify/" -x.pdf "${HOME}/Documents/Books/"{Books,Other}"/"
covergen -a1.5
seriesmeta
