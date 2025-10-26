/* filepath: /Users/michael/Projects/MyOs/linker.ld */
OUTPUT_FORMAT(binary)
ENTRY(main)

SECTIONS
{
    . = 0x0500;
    
    .text : {
        *(.text*)
    }
    
    .rodata : {
        *(.rodata*)
    }
    
    .data : {
        *(.data*)
    }
    
    .bss : {
        *(.bss*)
        *(COMMON)
    }
}