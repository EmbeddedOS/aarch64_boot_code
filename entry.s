
.text
.globl vector_table_el1, vector_table_el2, vector_table_el3

// Vector tables must be placed at a 2KB-aligned address.

.macro qemu_print reg, len
    mov x10, #0x09000000
    mov x11, #\len
    mov x12, #\reg
1:
    ldrb w2, [x12] /* Get the first byte and clear all the rest. */
    str w2, [x10]
    cmp x11, #0
    beq 2f
    sub x11, x11, #1
    add x12, x12, #1
    b 1b
2:
.endm

.balign 0x800
vector_table_el1:
vector_table_el2:
// Exception from current EL while using SP_EL0.
el1_curr_el_sp0_sync:
    qemu_print error, error_len
.balign 0x80
el1_curr_el_sp0_irq:
    qemu_print error, error_len
.balign 0x80
el1_curr_el_sp0_fiq:
    qemu_print error, error_len
.balign 0x80
el1_curr_el_sp0_serror:
    qemu_print error, error_len
.balign 0x80
// Exception from current EL while using SP_EL1.
el1_curr_el_sp1_sync:
    qemu_print error, error_len
.balign 0x80
el1_curr_el_sp1_irq:
    qemu_print error, error_len
.balign 0x80
el1_curr_el_sp1_fiq:
    qemu_print error, error_len
.balign 0x80
el1_curr_el_sp1_serror:
    qemu_print error, error_len
.balign 0x80

// Exception from a lower EL and at least one lower EL is AArch64.
el1_lower_el_aarch64_sync:
    bl sync_handler
.balign 0x80
el1_lower_el_aarch64_irq:
    qemu_print error, error_len
.balign 0x80
el1_lower_el_aarch64_fiq:
    qemu_print error, error_len
.balign 0x80
el1_lower_el_aarch64_serror:
    qemu_print error, error_len
.balign 0x80

// Exception from a lower EL and all lower ELs are AArch32.
el1_lower_el_aarch32_sync:
    qemu_print error, error_len
.balign 0x80
el1_lower_el_aarch32_irq:
    qemu_print error, error_len
.balign 0x80
el1_lower_el_aarch32_fiq:
    qemu_print error, error_len
.balign 0x80
el1_lower_el_aarch32_serror:
    qemu_print error, error_len

.balign 0x800
vector_table_el3:
// Exception from current EL while using SP_EL0.
el3_curr_el_sp0_sync:
    qemu_print error, error_len
.balign 0x80
el3_curr_el_sp0_irq:
    qemu_print error, error_len
.balign 0x80
el3_curr_el_sp0_fiq:
    qemu_print error, error_len
.balign 0x80
el3_curr_el_sp0_serror:
    qemu_print error, error_len
.balign 0x80
// Exception from current EL while using SP_EL1.
el3_curr_el_sp1_sync:
    qemu_print error, error_len
.balign 0x80
el3_curr_el_sp1_irq:
    qemu_print error, error_len
.balign 0x80
el3_curr_el_sp1_fiq:
    qemu_print error, error_len
.balign 0x80
el3_curr_el_sp1_serror:
    qemu_print error, error_len
.balign 0x80

// Exception from a lower EL and at least one lower EL is AArch64.
el3_lower_el_aarch64_sync:
    qemu_print error, error_len
.balign 0x80
el3_lower_el_aarch64_irq:
    qemu_print error, error_len
.balign 0x80
el3_lower_el_aarch64_fiq:
    qemu_print error, error_len
.balign 0x80
el3_lower_el_aarch64_serror:
    qemu_print error, error_len
.balign 0x80

// Exception from a lower EL and all lower ELs are AArch32.
el3_lower_el_aarch32_sync:
    qemu_print error, error_len
.balign 0x80
el3_lower_el_aarch32_irq:
    qemu_print error, error_len
.balign 0x80
el3_lower_el_aarch32_fiq:
    qemu_print error, error_len
.balign 0x80
el3_lower_el_aarch32_serror:
    qemu_print error, error_len

sync_handler:
    mov x14, 0x09000000
    mov x15, 'A'
    str x15, [x14]
    bl svc_handler
    eret
    stp x20, x21, [sp, #-16]!

    mov x21, sp
    sub x20, sp, #192
    and sp, x20, #~0b1111

    stp x0, x1, [sp, #0]

    add x1, x21, #16
    ldp x20, x21, [x21]

    stp x2, x3, [sp, #16]
    stp x4, x5, [sp, #32]
    stp x6, x7, [sp, #48]
    stp x8, x9, [sp, #64]
    stp x10, x11, [sp, #80]
    stp x12, x13, [sp, #96]
    stp x14, x15, [sp, #112]
    stp x16, x17, [sp, #128]
    stp x18, x29, [sp, #144]
    stp x30, x1, [sp, #160]

    mrs x0, ESR_EL1
    mrs x1, FAR_EL1
    stp x0, x1, [sp, #176]

    mov x0, sp
    bl svc_handler

    ldp x2, x3, [sp, #16]
    ldp x4, x5, [sp, #32]
    ldp x6, x7, [sp, #48]
    ldp x8, x9, [sp, #64]
    ldp x10, x11, [sp, #80]
    ldp x12, x13, [sp, #96]
    ldp x14, x15, [sp, #112]
    ldp x16, x17, [sp, #128]
    ldp x18, x29, [sp, #144]
    ldp x30, x0, [sp, #160]
    mov x1, sp
    mov sp, x0
    ldp x0, x1, [x1, #0]

    eret

error: .asciz "Error happen\n"
error_len = . - error - 1
