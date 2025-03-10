# Aarch64 bare metal boot code

## What this project do

Building bare metal boot code for AArch64 architecture, that's able to do:

- Booting system from ROM as a bootloader.
- Booting system from RAM as a kernel.
- Self-relocating from ROM to RAM and start executing.
- Able to boot from any Exception Level (EL3->EL0).
- Run the EL0 code in C, and request `svc` system call to the kernel (EL1 code) and get the result.
- Implement a system call dispatcher in EL1.

The blog that tells every details about this project here [Blog](https://embeddedos.github.io/posts/aarch64-bare-metal-boot-code/).

## How to build

Download the toolchain from ARM official website, and change the cross compiler in Makefile to your path:

```text
CROSS_COMPILE=../linux/toolchain/bin/aarch64-none-linux-gnu-
```

And then `make`.

## How to test

I'm using QEMU as a platform, that you can change the EL by using option `virtualization` and `secure`. And also the `-bios` option tell the QEMU that our firmware will run as ROM code, `-kernel` option means run as kernel and start from RAM.

- Start from EL3 as a ROM boot code:

```bash
qemu-system-aarch64 -M virt,virtualization=on,secure=on -cpu cortex-a57 -nographic -bios boot.bin -D log.txt -d int
```

- Start from EL2 as a ROM boot code:

```bash
qemu-system-aarch64 -M virt,virtualization=on,secure=off -cpu cortex-a57 -nographic -bios boot.bin -D log.txt -d int
```

- Start from EL1 as a ROM boot code:

```bash
qemu-system-aarch64 -M virt,virtualization=off,secure=off -cpu cortex-a57 -nographic -bios boot.bin -D log.txt -d int
```

- Start from EL3 as a kernel:

```bash
qemu-system-aarch64 -M virt,virtualization=on,secure=on -cpu cortex-a57 -nographic -kernel boot.elf -D log.txt -d int
```

- Start from EL2 as a kernel:

```bash
qemu-system-aarch64 -M virt,virtualization=on,secure=off -cpu cortex-a57 -nographic -bios boot.elf -D log.txt -d int
```

- Start from EL1 as a kernel:

```bash
qemu-system-aarch64 -M virt,virtualization=off,secure=off -cpu cortex-a57 -nographic -bios boot.elf -D log.txt -d int
```
