#!/bin/bash
#
# Optional parameteres below:
set -o nounset
set -o errexit

CONFIG_HOST=`echo ${MACHTYPE} | sed -e 's/-[^-]*/-cross/'`
CONFIG_PKG_VERSION="Simple x86_64 Operating System"
CONFIG_BUG_URL="https://github.com/LeeKyuHyuk/Simple-x86_64-Operating-System/issues"

# End of optional parameters

function step() {
  echo -e "\e[7m\e[1m>>> $1\e[0m"
}

function success() {
  echo -e "\e[1m\e[32m$1\e[0m"
}

function error() {
  echo -e "\e[1m\e[31m$1\e[0m"
}

function extract() {
  case $1 in
    *.tgz) tar -zxf $1 -C $2 ;;
    *.tar.gz) tar -zxf $1 -C $2 ;;
    *.tar.bz2) tar -jxf $1 -C $2 ;;
    *.tar.xz) tar -Jxf $1 -C $2 ;;
  esac
}

function check_tarballs {
  LIST_OF_TARBALLS="
  binutils-$CONFIG_BINUTILS_VERSION.tar.xz
  gcc-$CONFIG_GCC_VERSION.tar.xz
  mpfr-$CONFIG_MPFR_VERSION.tar.xz
  gmp-$CONFIG_GMP_VERSION.tar.xz
  mpc-$CONFIG_MPC_VERSION.tar.gz
  "

  for tarball in $LIST_OF_TARBALLS ; do
    if ! [[ -f $SOURCES_DIR/$tarball ]] ; then
      error "[!!!ERROR!!!] Can't find $tarball"
      exit 1
    fi
  done
}

function timer {
  if [[ $# -eq 0 ]]; then
    echo $(date '+%s')
  else
    local stime=$1
    etime=$(date '+%s')
    if [[ -z "$stime" ]]; then stime=$etime; fi
    dt=$((etime - stime))
    ds=$((dt % 60))
    dm=$(((dt / 60) % 60))
    dh=$((dt / 3600))
    printf '%02d:%02d:%02d' $dh $dm $ds
  fi
}

if [[ "$(uname -m)" != "x86_64" ]]; then
  error "[!!!ERROR!!!] Your build environment is not x86_64." && exit
fi

check_tarballs

total_build_time=$(timer)

rm -rf $BUILD_DIR $TOOLS_DIR
mkdir -pv $BUILD_DIR $TOOLS_DIR
ln -svf . $TOOLS_DIR/usr

step "[1/7] Binutils $CONFIG_BINUTILS_VERSION"
extract $SOURCES_DIR/binutils-$CONFIG_BINUTILS_VERSION.tar.xz $BUILD_DIR
( cd $BUILD_DIR/binutils-$CONFIG_BINUTILS_VERSION && \
./configure \
--target=$CONFIG_TARGET \
--prefix=$TOOLS_DIR/usr \
--enable-64-bit-bfd \
--disable-shared \
--disable-nls )
make -j$PARALLEL_JOBS configure-host -C $BUILD_DIR/binutils-$CONFIG_BINUTILS_VERSION
make -j$PARALLEL_JOBS LDFLAGS="-all-static" -C $BUILD_DIR/binutils-$CONFIG_BINUTILS_VERSION
make -j$PARALLEL_JOBS install -C $BUILD_DIR/binutils-$CONFIG_BINUTILS_VERSION
rm -rf $BUILD_DIR/binutils-$CONFIG_BINUTILS_VERSION

step "[2/7] GMP $CONFIG_GMP_VERSION"
extract $SOURCES_DIR/gmp-$CONFIG_GMP_VERSION.tar.xz $BUILD_DIR
( cd $BUILD_DIR/gmp-$CONFIG_GMP_VERSION && \
./configure \
--host=$CONFIG_TARGET \
--prefix=$TOOLS_DIR/usr \
--disable-shared \
--enable-static )
make -j$PARALLEL_JOBS -C $BUILD_DIR/gmp-$CONFIG_GMP_VERSION
make -j$PARALLEL_JOBS install -C $BUILD_DIR/gmp-$CONFIG_GMP_VERSION
rm -rf $BUILD_DIR/gmp-$CONFIG_GMP_VERSION

step "[3/7] MPFR $CONFIG_MPFR_VERSION"
extract $SOURCES_DIR/mpfr-$CONFIG_MPFR_VERSION.tar.xz $BUILD_DIR
( cd $BUILD_DIR/mpfr-$CONFIG_MPFR_VERSION && \
./configure \
--host=$CONFIG_TARGET \
--prefix=$TOOLS_DIR/usr \
--with-gmp=$TOOLS_DIR/usr \
--disable-shared \
--enable-static \
--enable-thread-safe )
make -j$PARALLEL_JOBS -C $BUILD_DIR/mpfr-$CONFIG_MPFR_VERSION
make -j$PARALLEL_JOBS install -C $BUILD_DIR/mpfr-$CONFIG_MPFR_VERSION
rm -rf $BUILD_DIR/mpfr-$CONFIG_MPFR_VERSION

step "[4/7] MPC $CONFIG_MPC_VERSION"
extract $SOURCES_DIR/mpc-$CONFIG_MPC_VERSION.tar.gz $BUILD_DIR
( cd $BUILD_DIR/mpc-$CONFIG_MPC_VERSION && \
./configure \
--host=$CONFIG_TARGET \
--prefix=$TOOLS_DIR/usr \
--with-mpfr=$TOOLS_DIR/usr \
--with-gmp=$TOOLS_DIR/usr \
--disable-shared \
--enable-static )
make -j$PARALLEL_JOBS -C $BUILD_DIR/mpc-$CONFIG_MPC_VERSION
make -j$PARALLEL_JOBS install -C $BUILD_DIR/mpc-$CONFIG_MPC_VERSION
rm -rf $BUILD_DIR/mpc-$CONFIG_MPC_VERSION

step "[5/7] GCC $CONFIG_GCC_VERSION"
extract $SOURCES_DIR/gcc-$CONFIG_GCC_VERSION.tar.xz $BUILD_DIR
( cd $BUILD_DIR/gcc-$CONFIG_GCC_VERSION && \
./configure \
--target=$CONFIG_TARGET \
--prefix=$TOOLS_DIR/usr \
--disable-nls \
--enable-languages=c \
--without-headers \
--disable-shared \
--enable-multilib \
--with-system-zlib \
--with-gmp=$TOOLS_DIR/usr \
--with-mpfr=$TOOLS_DIR/usr \
--with-mpc=$TOOLS_DIR/usr \
--with-pkgversion="$CONFIG_PKG_VERSION" \
--with-bugurl="$CONFIG_BUG_URL" )
make -j$PARALLEL_JOBS configure-host -C $BUILD_DIR/gcc-$CONFIG_GCC_VERSION
make -j$PARALLEL_JOBS all-gcc -C $BUILD_DIR/gcc-$CONFIG_GCC_VERSION
make -j$PARALLEL_JOBS install-gcc -C $BUILD_DIR/gcc-$CONFIG_GCC_VERSION
rm -rf $BUILD_DIR/gcc-$CONFIG_GCC_VERSION

step "[6/7] Check Binutils $CONFIG_BINUTILS_VERSION"
$TOOLS_DIR/usr/bin/$CONFIG_TARGET-ld --help | grep "supported "

step "[7/7] Check GCC $CONFIG_GCC_VERSION"
$TOOLS_DIR/usr/bin/$CONFIG_TARGET-gcc -dumpspecs | grep -A1 multilib_options

success "\nTotal toolchain build time: $(timer $total_build_time)\n"
