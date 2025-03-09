
.text
.globl vector_table_el1, vector_table_el2, vector_table_el3

// Vector tables must be placed at a 2KB-aligned address.

.balign 0x800
vector_table_el1:
el1_curr_el_sp0_sync:
    b .
.balign 0x80
el1_curr_el_sp0_irq:
    b .
.balign 0x80
el1_curr_el_sp0_fiq:
    b .
.balign 0x80
el1_curr_el_sp0_serror:
    b .
.balign 0x80
el1_curr_el_sp1_sync:
    b .
.balign 0x80
el1_curr_el_sp1_irq:
    b .
.balign 0x80
el1_curr_el_sp1_fiq:
    b .
.balign 0x80
el1_curr_el_sp1_serror:
    b .
.balign 0x80
el1_lower_el_aarch64_sync:
    b el1_lower_el_aarch64_sync_handler
.balign 0x80
el1_lower_el_aarch64_irq:
    b .
.balign 0x80
el1_lower_el_aarch64_fiq:
    b .
.balign 0x80
el1_lower_el_aarch64_serror:
    b .
.balign 0x80
el1_lower_el_aarch32_sync:
    b .
.balign 0x80
el1_lower_el_aarch32_irq:
    b .
.balign 0x80
el1_lower_el_aarch32_fiq:
    b .
.balign 0x80
el1_lower_el_aarch32_serror:
    b .

.balign 0x800
vector_table_el2:
el2_curr_el_sp0_sync:
    b .
.balign 0x80
el2_curr_el_sp0_irq:
    b .
.balign 0x80
el2_curr_el_sp0_fiq:
    b .
.balign 0x80
el2_curr_el_sp0_serror:
    b .
.balign 0x80
el2_curr_el_sp1_sync:
    b .
.balign 0x80
el2_curr_el_sp1_irq:
    b .
.balign 0x80
el2_curr_el_sp1_fiq:
    b .
.balign 0x80
el2_curr_el_sp1_serror:
    b .
.balign 0x80
el2_lower_el_aarch64_sync:
    b .
.balign 0x80
el2_lower_el_aarch64_irq:
    b .
.balign 0x80
el2_lower_el_aarch64_fiq:
    b .
.balign 0x80
el2_lower_el_aarch64_serror:
    b .
.balign 0x80
el2_lower_el_aarch32_sync:
    b .
.balign 0x80
el2_lower_el_aarch32_irq:
    b .
.balign 0x80
el2_lower_el_aarch32_fiq:
    b .
.balign 0x80
el2_lower_el_aarch32_serror:
    b .

.balign 0x800
vector_table_el3:
el3_curr_el_sp0_sync:
    b .
.balign 0x80
el3_curr_el_sp0_irq:
    b .
.balign 0x80
el3_curr_el_sp0_fiq:
    b .
.balign 0x80
el3_curr_el_sp0_serror:
    b .
.balign 0x80
el3_curr_el_sp1_sync:
    b .
.balign 0x80
el3_curr_el_sp1_irq:
    b .
.balign 0x80
el3_curr_el_sp1_fiq:
    b .
.balign 0x80
el3_curr_el_sp1_serror:
    b .
.balign 0x80
el3_lower_el_aarch64_sync:
    b .
.balign 0x80
el3_lower_el_aarch64_irq:
    b .
.balign 0x80
el3_lower_el_aarch64_fiq:
    b .
.balign 0x80
el3_lower_el_aarch64_serror:
    b .
.balign 0x80
el3_lower_el_aarch32_sync:
    b .
.balign 0x80
el3_lower_el_aarch32_irq:
    b .
.balign 0x80
el3_lower_el_aarch32_fiq:
    b .
.balign 0x80
el3_lower_el_aarch32_serror:
    b .

.balign 0x80
.macro save_trap_frame el
	stp	x29, x30, [sp, #-16]!
    stp	x27, x28, [sp, #-16]!
	stp	x25, x26, [sp, #-16]!
	stp	x23, x24, [sp, #-16]!
	stp	x21, x22, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	stp	x17, x18, [sp, #-16]!
	stp	x15, x16, [sp, #-16]!
	stp	x13, x14, [sp, #-16]!
	stp	x11, x12, [sp, #-16]!
	stp	x9, x10, [sp, #-16]!
	stp	x7, x8, [sp, #-16]!
	stp	x5, x6, [sp, #-16]!
	stp	x3, x4, [sp, #-16]!
	stp	x1, x2, [sp, #-16]!

    mrs x21, spsr_\el
    stp x21, x0, [sp, #-16]!
.endm

.macro restore_trap_frame el
	ldp	x21, x0, [sp], #16
	msr	spsr_\el, x21
    ldp x1, x2, [sp], #16
    ldp x3, x4, [sp], #16
    ldp x5, x6, [sp], #16
    ldp x7, x8, [sp], #16
    ldp x9, x10, [sp], #16
    ldp x11, x12, [sp], #16
    ldp x13, x14, [sp], #16
    ldp x15, x16, [sp], #16
    ldp x17, x18, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x23, x24, [sp], #16
    ldp x25, x26, [sp], #16
    ldp x27, x28, [sp], #16
    ldp x29, x30, [sp], #16
.endm

el1_lower_el_aarch64_sync_handler:
    save_trap_frame el1
    bl el1_lower_el_aarch64_sync_handler_c
    restore_trap_frame el1
    eret

