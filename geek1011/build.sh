#!/bin/bash
set -e
cd "$(dirname "$0")"

rm -rf build
mkdir build
cd build

wget -O- "https://github.com/kobolabs/Kobo-Reader/blob/master/toolchain/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz?raw=true" | tar xvJf - # TODO: use toolchain with old linux headers
wget -O- "https://www.zlib.net/zlib-1.2.11.tar.xz" | tar xvJf -
wget -O- "https://www.openssl.org/source/openssl-1.1.1d.tar.gz" | tar xvzf -
wget -O- "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz" | tar xzvf -
wget -O- "https://matt.ucc.asn.au/dropbear/releases/dropbear-2019.78.tar.bz2" | tar xvjf -
mkdir stg

export HOST="arm-linux-gnueabihf"
export CC="$PWD/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc"
export CXX="$PWD/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++"
export DESTDIR="$PWD/stg"
export PREFIX="/usr/local/geek1011"

cd zlib-1.2.11
	./configure \
		--static \
		--prefix="$PREFIX"
	make
	make install DESTDIR="$DESTDIR"
cd ..

cd openssl-1.1.1d
	./Configure \
		no-asm \
		no-shared \
		--prefix="$PREFIX" \
		linux-armv4
	make install DESTDIR="$DESTDIR"
cd ..

cd openssh-8.1p1
	./configure \
		--host="$HOST" \
		--enable-static \
		--without-openssl \
		--with-zlib="$DESTDIR$PREFIX" \
		--prefix="$PREFIX" \
		--bindir="$PREFIX" \
		--with-cflags="-I\"$DESTDIR$PREFIX/include\"" \
		--with-ldflags="-static -L\"$DESTDIR$PREFIX/lib\"" # note: openssh is only used for sftp-server, so other flags aren't needed, also, openssl isn't needed, but compilation fails without it
	make sftp-server
	cp   sftp-server "$DESTDIR$PREFIX/sftp-server"
cd ..

cd dropbear-2019.78
	echo "#define SFTPSERVER_PATH     \"$PREFIX/sftp-server\"" >> localoptions.h
	echo "#define DSS_PRIV_FILENAME   \"$PREFIX/dss_key\""     >> localoptions.h
	echo "#define RSA_PRIV_FILENAME   \"$PREFIX/rsa_key\""     >> localoptions.h
	echo "#define ECDSA_PRIV_FILENAME \"$PREFIX/ecdsa_key\""   >> localoptions.h
	./configure \
		--host="$HOST" \
		--enable-static \
		--disable-lastlog \
		--disable-utmp \
		--disable-wtmp \
		--with-zlib="$DESTDIR$PREFIX" \
		--prefix="$PREFIX" \
		--bindir="$PREFIX"
	make \
		PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" \
		DESTDIR="$DESTDIR" \
		SCPPROGRESS=1 \
		MULTI=1 \
		install
cd ..

rm -rf ../root
mkdir ../root
cd ../root
	mkdir -p ".$PREFIX/"
	cp "$DESTDIR$PREFIX/dropbearmulti" ".$PREFIX/"
	cp "$DESTDIR$PREFIX/sftp-server" ".$PREFIX/"
	cat <<-EOF > ".$PREFIX/init"
		#!/bin/sh
		"$PREFIX/dropbearmulti" dropbear -BFER &
	EOF
	chmod +x ".$PREFIX/init"
	mkdir -p "./etc/udev/rules.d/"
	cat <<-EOF > "./etc/udev/rules.d/99-geek1011.rules"
		KERNEL=="loop0", RUN+="$PREFIX/init"
	EOF
	find .
cd ..