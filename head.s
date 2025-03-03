.text

.globl _start, svc_handler

/*
 * @brief - This function write characters into UART Tx Register that based on
 *          AArch64 `virt` machine.
 */
.macro qemu_print reg, len
    str x10, [sp, #-64]!
    str x11, [sp, #-64]!
    str x12, [sp, #-64]!

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
    ldr   x12, [sp], #64
    ldr   x11, [sp], #64
    ldr   x10, [sp], #64
.endm

_start:
    ldr x30, =stack_top
    mov sp, x30

    qemu_print hello_message, hello_message_len

    /* Check current EL.*/
    mrs x1, CurrentEL
    cmp x1, 0
    beq in_el0

    cmp x1, 0b0100
    beq in_el1

    cmp x1, 0b1000
    beq in_el2

    cmp x1, 0b1100
    beq in_el3

    b .

in_el3:
    qemu_print in_el3_message, in_el3_message_len
    /* TODO: handle secure monitor layer. */
    b .

in_el2:
    qemu_print in_el2_message, in_el2_message_len
    /* TODO: handle hypervisor layer. */
    MSR SCTLR_EL1, XZR 
    MRS X0, HCR_EL2
    ORR X0, X0, #(1<<31) // RW=1 EL1 Execution state is AArch64.
    MSR HCR_EL2, X0
    MOV X0, #0b00101 // DAIF=0000
    MSR SPSR_EL2, X0 // M[4:0]=00101 EL1h must match HCR_EL2.RW.
    ADR X0, in_el1 // el1_entry points to the first instruction of
    MSR ELR_EL2, X0 // EL1 code.
    ERET

in_el1:
    qemu_print in_el1_message, in_el1_message_len

    /* Load vector table. */ 
    ldr x1, =vector_table_el1
    msr VBAR_EL1, x1

    // Determine the EL0 Execution state.
    MOV X0, #0b00000 // DAIF=0000 M[4:0]=00000 EL0t.
    MSR SPSR_EL1, X0
    ADR x0, in_el0
    MSR ELR_EL1, X0 // EL0 code.
    ERET

in_el0:
    ldr x30, =stack_top
    mov sp, x30
    qemu_print in_el0_message, in_el0_message_len
    bl main

    b .

svc_handler:
    qemu_print svc_message, svc_message_len

svc_message: .asciz "SVC handler!\n"
svc_message_len = . - svc_message - 1

hello_message: .asciz "Aarch64 bare metal code!\n"
hello_message_len = . - hello_message - 1

in_el0_message: .asciz "In EL0!\n"
in_el0_message_len = . - in_el0_message - 1

in_el1_message: .asciz "In EL1!\n"
in_el1_message_len = . - in_el1_message - 1

in_el2_message: .asciz "In EL2!\n"
in_el2_message_len = . - in_el2_message - 1

in_el3_message: .asciz "In EL3!\n"
in_el3_message_len = . - in_el3_message - 1
