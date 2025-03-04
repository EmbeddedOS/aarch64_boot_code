SECTIONS
{
 . = 0x40000000;
 .start : {head.o (.text)}
 .text : { *(.text) }
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
 . = ALIGN(8);
 . = . + 0x100;
 el3_stack_top = .;
 . = . + 0x100;
 el2_stack_top = .;
 . = . + 0x100;
 el1_stack_top = .;
 . = . + 0x1000;
 el0_stack_top = .;
 stack_top = .;
}
