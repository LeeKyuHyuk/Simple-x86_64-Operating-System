# Simple x86_64 Operating System

### Preparing Build Environment

Debian 9 is recommended.

#### **Debian 9**

```bash
$ sudo apt install make gcc g++ wget git qemu-system ca-certificates xz-utils
```

### Get Simple x86_64 Operating System

``` bash
git clone --depth 1 git@github.com:LeeKyuHyuk/Simple-x86_64-Operating-System.git
```

### Build Simple x86_64 Operating System

Download the source code by doing `make download`.

``` bash
make download
make all
```

### Build Toolchain

``` bash
make toolchain
```

```
$ x86_64-pc-linux-gcc --version
x86_64-pc-linux-gcc (Simple x86_64 Operating System) 8.2.0
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ x86_64-pc-linux-ld --help | grep "supported "
x86_64-pc-linux-ld: supported targets: elf64-x86-64 elf32-i386 elf32-iamcu elf32-x86-64 pei-i386 pei-x86-64 elf64-l1om elf64-k1om elf64-little elf64-big elf32-little elf32-big plugin srec symbolsrec verilog tekhex binary ihex
x86_64-pc-linux-ld: supported emulations: elf_x86_64 elf32_x86_64 elf_i386 elf_iamcu elf_l1om elf_k1om


$ x86_64-pc-linux-gcc -dumpspecs | grep -A1 multilib_options
*multilib_options:
m64/m32
```

### Built With

- Binutils 2.31.1
- GCC 8.2.0
- MPFR 4.0.1
- GMP 6.1.2
- MPC 1.1.0

### Thanks to

- [IT EXPERT, 64비트 멀티코어 OS 원리와 구조](https://books.google.co.kr/books?id=RoJxDwAAQBAJ)
- [OSDev Wiki](https://wiki.osdev.org)
