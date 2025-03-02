.text

.globl _start, svc_handler
_start:
    LDR x30, =stack_top
    mov sp, x30

    /* Check current EL.*/
    MRS x1, CurrentEL
    

    LDR x1, =vector_table_el1
    MSR VBAR_EL1, x1


   # adr x0, in_el0
  # msr ELR_EL1, x0

#    mov x0, xzr
#    orr x0, #0b01001

#    msr SPSR_EL1, x0

   eret
    mov x0, 0x09000000
    # MRS x1, CurrentEL
    # str x1,[x0]

    mov x1, 'B'
    str x1,[x0]

in_el0:
    mov x0, 0x09000000
    # MRS x1, CurrentEL
    # str x1,[x0]

    mov x1, 'A'
    str x1,[x0]


    mov x1, '\n'
    str x1,[x0]


    bl main

svc_handler:
    mov x0, 0x09000000
    # MRS x1, CurrentEL
    # str x1,[x0]

    mov x1, 'C'
    str x1, [x0]