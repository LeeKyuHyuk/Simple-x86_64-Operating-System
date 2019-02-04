## Chapter 1: Cross Compiler를 빌드하고, 빌드환경을 구축해보자!

### Build Cross Compiler

> 크로스 컴파일러(Cross Compiler)는 컴파일러가 실행되는 플랫폼이 아닌 다른 플랫폼에서 실행 가능한 코드를 생성할 수 있는 컴파일러이다.  
크로스 컴파일러 툴은 임베디드 시스템 혹은 여러 플랫폼에서 실행파일을 생성하는데 사용된다.
이것은 운영 체제를 지원하지 않는 마이크로컨트롤러와 같이 컴파일이 실현 불가능한 플랫폼에 컴파일하는데 사용된다.  
이것은 시스템이 사용하는데 하나 이상의 플랫폼을 쓰는 반가상화에 이 도구를 사용하는 것이 더 일반적이게 되었다.  
[Wikipedia - 크로스 컴파일러](https://ko.wikipedia.org/wiki/크로스%20컴파일러)

![GNU GCC Cross Compiler](./GNU-GCC-Cross-Compiler.png)  
Picture Source : *[Preshing on Programming - How to Build a GCC Cross-Compiler
](https://preshing.com/20141119/how-to-build-a-gcc-cross-compiler)*

### Step 1. Download Source code

```
$ wget https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.xz
$ wget https://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz
$ wget https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.1.tar.xz
$ wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
$ wget https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz
```

### Step 2. Build GNU Binutils

> GNU 바이너리 유틸리티(GNU Binary Utilities) 또는 GNU Binutils는 여러 종류의 오브젝트 파일 형식들을 조작하기 위한 프로그래밍 도구 모음이다.  
> [Wikipedia - GNU 바이너리 유틸리티](https://ko.wikipedia.org/wiki/GNU_바이너리_유틸리티)

```
$ tar xvJf binutils-2.31.1.tar.xz
$ cd binutils-2.31.1
$ ./configure \
  --target=x86_64-pc-linux \
  --prefix=/home/leekyuhyuk/workspace/tools \
  --enable-64-bit-bfd \
  --disable-shared \
  --disable-nls
$ make
$ make install
$ /home/leekyuhyuk/workspace/tools/bin/x86_64-pc-linux-as -version
    GNU assembler (GNU Binutils) 2.31.1
    Copyright (C) 2018 Free Software Foundation, Inc.
    This program is free software; you may redistribute it under the terms of
    the GNU General Public License version 3 or later.
    This program has absolutely no warranty.
    This assembler was configured for a target of `x86_64-pc-linux'.
$ cd ..
```

- `--target`: 컴파일해서 만들어진 바이너리가 만들어내는 바이너리가 실행되는 시스템
- `--prefix` : PREFIX에 binutils를 설치합니다.
  - 원하는 경로를 입력하면 됩니다. 저는 `/home/leekyuhyuk/workspace/tools`로 입력하였습니다.
- `--enable-64-bit-bfd` : 64bit target를 지원합니다.
- `--disable-shared` : Static Library로 빌드합니다.
- `--disable-nls` : 모든 메세지를 영어로 출력합니다.

### Step 3. Build GNU GMP

```
$ tar xvJf gmp-6.1.2.tar.xz
$ cd gmp-6.1.2
$ ./configure \
  --host=x86_64-pc-linux \
  --prefix=/home/leekyuhyuk/workspace/tools \
  --disable-shared \
  --enable-static
$ make
$ make install
$ cd ..
```

- `--host` : 컴파일해서 만들어진 바이너리가 실행되는 시스템

### Step 4. Build GNU MPFR

```
$ tar xvJf mpfr-4.0.1.tar.xz
$ cd mpfr-4.0.1
$ ./configure \
  --host=x86_64-pc-linux \
  --prefix=/home/leekyuhyuk/workspace/tools \
  --with-gmp=/home/leekyuhyuk/workspace/tools \
  --disable-shared \
  --enable-static \
  --enable-thread-safe
$ make
$ make install
$ cd ..
```

- `--enable-thread-safe` : Compiler-Level의 TLS(Thread Local Storage)를 사용하여 Thread Safe하게 MPFR를 빌드합니다.

### Step 5. Build GNU MPC

```
$ tar xvzf mpc-1.1.0.tar.gz
$ cd mpc-1.1.0
$ ./configure \
  --host=x86_64-pc-linux \
  --prefix=/home/leekyuhyuk/workspace/tools \
  --with-mpfr=/home/leekyuhyuk/workspace/tools \
  --with-gmp=/home/leekyuhyuk/workspace/tools \
  --disable-shared \
  --enable-static
$ make
$ make install
$ cd ..
```

### Step 6. Build GNU GCC

```
$ tar xvJf gcc-8.2.0.tar.xz
$ cd gcc-8.2.0
$ ./configure \
--target=x86_64-pc-linux \
--prefix=/home/leekyuhyuk/workspace/tools \
--disable-nls \
--enable-languages=c \
--without-headers \
--disable-shared \
--enable-multilib \
--with-system-zlib \
--with-gmp=/home/leekyuhyuk/workspace/tools \
--with-mpfr=/home/leekyuhyuk/workspace/tools \
--with-mpc=/home/leekyuhyuk/workspace/tools
$ make
$ make install
$ cd ..
```

- `--enable-languages` : Compiler나 Runtime Library들이 어떤걸로 빌드되어야 할지 설정합니다.
- `--enable-multilib` : 32비트, 64비트 코드를 모두 생성할 수 있게합니다.
- `--with-system-zlib` : GCC가 내부 복사본이 아닌 Host에 있는 zlib Library로 Link하도록 설정합니다.
