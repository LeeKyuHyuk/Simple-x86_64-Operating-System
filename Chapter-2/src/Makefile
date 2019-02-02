all:
	x86_64-linux-gnu-as -c bootloader.S -o bootloader.o
	x86_64-linux-gnu-ld -Ttext 0x7c00 --oformat=binary bootloader.o -o bootloader.bin

run:
	qemu-system-x86_64 -M pc -fda bootloader.bin

clean:
	rm -rfv *.o *.bin
