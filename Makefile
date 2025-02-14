PREFIX:="$(HOME)/opt/cross"

env:
	./.env

binutils-i386:
	cd ./src; \
	mkdir -p build-binutils; \
	rm -rf build-binutils/*; \
	cd build-binutils; \
	../binutils/configure --target=i386-elf --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror; \
	make -j 8; \
	make install; \
	cd ..; \
	cd ..

gcc-i386:
	cd ./src; \
	mkdir -p build-gcc; \
	cd build-gcc; \
	../gcc/configure --target=i386-elf --prefix="$(PREFIX)" --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx; \
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

patch:
	-cd ./src/binutils/ && git apply ../../GWOS_configs/binutils_gwos.patch

patch_docker:
	cd ./patch_docker && docker build -t gwos_patch .
	docker run -v ./src/binutils/:/binutils gwos_patch

build_toolchain_image:
	cd ./build_docker && docker build -t gwos_toolchain_build .

binutils-gwos:
	TARGET=i386-gwos
	cd ./src; \
	mkdir -p build-binutils; \
	rm -rf build-binutils/*; \
	cd build-binutils; \
	../binutils/configure --target=i386-gwos --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror; \
	make -j 8; \
	make install; \
	cd ..; \
	cd ..

build: env patch binutils-i386 gcc-i386 binutils-gwos

default: build
