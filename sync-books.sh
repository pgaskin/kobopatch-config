#!/bin/bash
dictutil I -lgt -nGOTDict "$HOME/Documents/Books/Books/.kobodict/gotdict.zip"
dictutil I -lox -nOxford "$HOME/Documents/Books/Books/.kobodict/oxford.zip"
dictutil I -lwb -nWebster1913 "$HOME/Documents/Books/Books/.kobodict/webster1913.zip"
kepubify -u -o"$(kobo-find -w -f)/kepubify/" -x.pdf "${HOME}/Documents/Books/"{Books,Other}"/"
covergen -a1.5
seriesmeta
