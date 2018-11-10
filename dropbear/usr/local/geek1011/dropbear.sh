#!/bin/sh
[ -f /usr/local/geek1011/dss_key ] || /usr/local/geek1011/dropbearmulti dropbearkey -t dss -f /usr/local/geek1011/dss_key
[ -f /usr/local/geek1011/rsa_key ] || /usr/local/geek1011/dropbearmulti dropbearkey -t rsa -f /usr/local/geek1011/rsa_key
[ -f /usr/local/geek1011/ecdsa_key ] || /usr/local/geek1011/dropbearmulti dropbearkey -t ecdsa -f /usr/local/geek1011/ecdsa_key
/usr/local/geek1011/dropbearmulti dropbear -BFEr /usr/local/geek1011/dss_key -r /usr/local/geek1011/rsa_key -r /usr/local/geek1011/ecdsa_key
