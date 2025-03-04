.text

.globl _start, svc_handler

/*
 * @brief - This function write characters into UART Tx Register that based on
 *          AArch64 `virt` machine.
 */
.macro qemu_print reg, len
    // str x10, [sp, #64]!
    // str x11, [sp, #128]!
    // str x12, [sp, #192]!

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
    // ldr   x12, [sp], #64
    // ldr   x11, [sp], #128
    // ldr   x10, [sp], #192
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
    /* Secure monitor code. */
    qemu_print in_el3_message, in_el3_message_len

    ldr x1, =vector_table_el3       /* Load EL3 vector table.                 */ 
    msr vbar_el3, x1

    /* Set up Execution state before return to EL2. */
    msr sctlr_el2, xzr      /* Clear System Control Rergister.                */
    msr hcr_el2, xzr        /* Clear the Hypervisor Control Register.         */

    mrs x0, scr_el3         /* Configure Secure Control Register:             */
    orr x0, x0, #(1<<10)    /* EL2 exception state is AArch64.                */
    orr x0, x0, #(1<<0)     /* Non Secure state for EL1.                      */
    orr x0, x0, #(1<<1)
    orr x0, x0, #(1<<2)
    orr x0, x0, #(1<<3)
    and x0, x0, #(~(1<<62))
    msr scr_el3, x0

    mrs x0, sctlr_el2
    orr x0, x0, #(1<<25)
    orr x0, x0, #(1<<12)
    orr x0, x0, #(1<<1)
    orr x0, x0, #(1<<2)
    orr x0, x0, #(1<<3)
    msr sctlr_el2, x0


    mov x0, #0b000001001    /* DAIF[8:5]=0000 M[4:0]=01001 EL0 state:         */
    msr spsr_el3, x0        /* Select EL2 with SP_EL2.                        */

    ldr x30, =el2_stack_top
    msr sp_el2, x30

    adr x0, in_el2
    msr elr_el3, x0
    eret

in_el2:
    qemu_print in_el2_message, in_el2_message_len

    ldr x1, =vector_table_el2       /* Load EL2 vector table.                 */ 
    msr vbar_el2, x1

    /* Set up Execution state before return to EL1. */
    msr sctlr_el1, xzr      /* Clear System Control Register.                 */

    mrs x0, hcr_el2         /* Set bit 31th: RW the Execution state for EL1.  */
    orr x0, x0, #(1<<31)
    msr hcr_el2, x0

    mov x0, #0b111100101    /* DAIF[8:5]=0000 M[4:0]=00101 The state indicate */
    msr spsr_el2, X0        /* EL1 with SP_EL1.                               */

    ldr x30, =el1_stack_top
    msr sp_el1, x30

    adr x0, in_el1
    msr elr_el2, x0

    eret

in_el1:
    qemu_print in_el1_message, in_el1_message_len

    /* Set up Execution state before return to EL0. */
    ldr x1, =vector_table_el1       /* Load EL1 vector table.                 */ 
    msr vbar_el1, x1

    mov x0, #0b111100000    /* DAIF[8:5]=0000 M[4:0]=00000 EL0 state.             */
    msr spsr_el1, x0

    ldr x30, =el0_stack_top
    msr sp_el0, x30

    adr x0, in_el0
    msr elr_el1, x0

in_el0:
    qemu_print in_el0_message, in_el0_message_len
    svc 1
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
