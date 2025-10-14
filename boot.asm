[BITS 16]
org 0x7C00

start:
    cli                     ; Clear interrupts
    xor ax, ax              ; Clear ax register
    mov ss, ax              ; Set stack segment to 0
    mov ds, ax              ; Set data segment to 0
    mov es, ax              ; Set extra segment to 0

    mov [boot_drive], dl    ; Store boot drive number

times 509-($-$$) db 0       ; Limit the sector to 509 bytes
boot_drive db 0x00          ; Padding byte for boot drive number
dw 0xAA55                   ; Boot signature and last 2 bytes of the first sector