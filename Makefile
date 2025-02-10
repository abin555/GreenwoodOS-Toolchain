env:
	./.env

binutils:
	cd ./src
	mkdir build-binutils
	cd build-binutils
	../binutils-2.44/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
	make
	make install
	cd ../..

gcc:
	cd ./src
	mkdir build-gcc
	cd build-gcc
	../gcc-14.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx
	make all-gcc -j 4
	make all-target-libgcc -j 4
	make all-target-libstdc++-v3 -j 4
	make install-gcc
	make install-target-libgcc
	make install-target-libstdc++-v3
	cd ../..

build: env binutils gcc

default: build
