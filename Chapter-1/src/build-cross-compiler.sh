#!/bin/sh
export TARGET=x86_64-pc-linux
export PREFIX=$HOME/tools
export PATH=$PREFIX/bin:$PATH
export PARALLEL_JOBS=$(cat /proc/cpuinfo | grep cores | wc -l)

wget -c https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.xz
tar xvJf binutils-2.32.tar.xz
( cd binutils-2.32 && \
./configure \
--target=$TARGET \
--prefix=$PREFIX \
--enable-64-bit-bfd \
--disable-shared \
--disable-nls )
make -j$PARALLEL_JOBS configure-host -C binutils-2.32
make -j$PARALLEL_JOBS LDFLAGS="-all-static" -C binutils-2.32
make -j$PARALLEL_JOBS install -C binutils-2.32
rm -rf binutils-2.32

wget -c https://ftp.gnu.org/gnu/gcc/gcc-9.1.0/gcc-9.1.0.tar.xz
wget -c https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.xz
wget -c https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
wget -c https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz
tar xvJf gcc-9.1.0.tar.xz
tar xvJf mpfr-4.0.2.tar.xz
tar xvJf gmp-6.1.2.tar.xz
tar xvzf mpc-1.1.0.tar.gz
mv -v mpfr-4.0.2 gcc-9.1.0/mpfr
mv -v gmp-6.1.2 gcc-9.1.0/gmp
mv -v mpc-1.1.0 gcc-9.1.0/mpc
( cd gcc-9.1.0 && \
./configure \
--target=$TARGET \
--prefix=$PREFIX \
--disable-nls \
--enable-languages=c \
--without-headers \
--disable-shared \
--enable-multilib )
make -j$PARALLEL_JOBS configure-host -C gcc-9.1.0
make -j$PARALLEL_JOBS all-gcc -C gcc-9.1.0
make -j$PARALLEL_JOBS install-gcc -C gcc-9.1.0
rm -rf gcc-9.1.0
