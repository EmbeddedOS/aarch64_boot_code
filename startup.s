.globl _start
_start:
    LDR x30, =stack_pointer
    mov sp, x30
    bl main
