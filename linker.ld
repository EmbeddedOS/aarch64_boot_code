SECTIONS
{
 . = 0x40000000;
 .start : {head.o (.text)}
 .text : { *(.text) }
 .rodata : { *(.rodata) }
 .data : { *(.data) }
 _end_copy_image = .;
 .bss : { *(.bss COMMON) }
 . = ALIGN(8);
 . = . + 0x1000;
 el3_stack_top = .;
 . = . + 0x1000;
 el2_stack_top = .;
 . = . + 0x1000;
 el1_stack_top = .;
 . = . + 0x1000;
 el0_stack_top = .;
 stack_top = .;
 . = ALIGN(8);
}
