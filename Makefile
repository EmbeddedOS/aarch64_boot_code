CROSS_COMPILE=../linux/toolchain/bin/aarch64-none-linux-gnu-
CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
AS=$(CROSS_COMPILE)as
OBJCOPY=$(CROSS_COMPILE)objcopy
all:
	$(CC) -g -c main.c -o main.o
	$(CC) -S main.c -o main.s
	$(AS) -g -c head.s -o head.o
	$(AS) -g -c entry.s -o entry.o
	$(LD) -g -e _start -T linker.ld head.o main.o entry.o -o boot.elf
	$(OBJCOPY) -O binary boot.elf boot.bin
clean:
	rm -rf *.o *.bin *.elf