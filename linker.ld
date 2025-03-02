SECTIONS
{
 . = 0x40000000;
 .start : {head.o (.text)}
 .text : { *(.text) }
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
 . = ALIGN(8);
 . = . + 0x1000;
 stack_top = .;
}
