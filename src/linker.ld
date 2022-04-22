ENTRY(_start)
 
SECTIONS {
    /* QEMU loads the kernel in Flash here. I strongly suggest you look at the
     * memory map provided in the CoreTile TRM (see below).
     */
    . = 0x80010000;
 
    /* Make sure our entry stub goes first */
    .stub   : { _start.o(.text) }
    .text   : { *(.text) }
    .rodata : { *(.rodata) }
    .data   : { *(.data) }
    .bss    : { *(.bss COMMON) }
 
    STACK_BASE = .;
    . += 0x10000;
    STACK_TOP = .;
}