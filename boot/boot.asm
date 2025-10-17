[BITS 16]
org 0x7C00

start:
    cli
    xor ax, ax              ; Clear ax register
    mov ss, ax              ; Set stack segment to 0
    mov ds, ax              ; Set data segment to 0
    mov es, ax              ; Set extra segment to 0

    mov [boot_drive], dl    ; Store boot drive number

    call switch_to_protected_mode

    jmp $
main:
jmp $

%include "./boot/protected_mode.asm"
%include "./boot/gdt.asm"
boot_drive db 0x00              ; Padding byte for boot drive number

times 510-($-$$) db 0           ; Limit the sector to 510 bytes
dw 0xAA55                       ; Boot signature and last 2 bytes of the first sector