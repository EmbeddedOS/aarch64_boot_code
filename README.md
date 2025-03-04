# aarch64_boot_code

Aarch64 bare metal boot code.

```bash
qemu-system-aarch64 -M virt,virtualization=on,secure=off -cpu cortex-a57 -nographic -bios boot.bin
```
