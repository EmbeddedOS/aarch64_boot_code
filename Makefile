CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu-
CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
AS=$(CROSS_COMPILE)as
all:
	$(CC) -c main.c -o main.o
	$(AS) -c startup.s -o startup.o
	$(LD) -e _start -T linker.ld startup.o main.o -o boot.elf
