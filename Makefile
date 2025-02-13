PREFIX:="$(HOME)/opt/cross"

env:
	./.env

binutils-i386:
	TARGET=i386-elf
	cd ./src; \
	mkdir -p build-binutils; \
	rm -rf build-binutils/*; \
	cd build-binutils; \
	../binutils/configure --target=$(TARGET) --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror; \
	make -j 8; \
	make install; \
	cd ..; \
	cd ..

gcc-i386:
	TARGET=i386-elf
	cd ./src; \
	mkdir -p build-gcc; \
	cd build-gcc; \
	../gcc/configure --target=$(TARGET) --prefix="$(PREFIX)" --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx; \
	make all-gcc -j 8; \
	make all-target-libgcc -j 8; \
	make all-target-libstdc++-v3 -j 8; \
	make install-gcc; \
	make install-target-libgcc; \
	make install-target-libstdc++-v3; \
	cd ..; \
	cd ..

clean:
	rm -rf ./src/build-binutils
	rm -rf ./src/build-gcc

binutils-gwos: clean
	TARGET=i386-elf-gwos
	cd ./src; \
	mkdir -p build-binutils
	cp GWOS_configs/config.sub src/binutils/config.sub; \
	cp GWOS_configs/bfd_config.bfd src/binutils/bfd/config.bfd; \
	cp GWOS_configs/gas_configure.tgt src/binutils/gas/configure.tgt; \
	cp GWOS_configs/ld_configure.tgt src/binutils/ld/configure.tgt; \
	cp GWOS_configs/ld_emulparams_elf_i386_gwos.sh src/binutils/ld/emulparams/elf_i386_gwos.sh; \
	cp GWOS_configs/ld_emulparams_elf_x86_64_gwos.sh src/binutils/ld/emulparams/elf_x86_64_gwos.sh; \
	cp GWOS_configs/ld_Makefile.am src/binutils/ld/Makefile.am; \
#	make -C src/binutils/ld
	cd ./src/build-binutils; \
	../binutils/configure --target=$(TARGET) --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror; \
	make; \
	echo $(PWD); \
	make install
	cd ./src/binutils; \
	git restore .


build: env binutils-i386 gcc-i386

default: build
