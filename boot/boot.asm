[BITS 16]
org 0x7C00
global start

%include "./boot/constants.asm"

start:
    cli
    xor ax, ax              ; Clear ax register
    mov ss, ax              ; Set stack segment to 0
    mov ds, ax              ; Set data segment to 0
    mov es, ax              ; Set extra segment to 0

    mov sp, 0x7C00         ; Set stack pointer

    mov [boot_drive], dl    ; Store boot drive number

    mov bx, 0x0500          ; Memory address to load the next stage
    mov dl, [boot_drive]     ; Boot drive number
    mov al, 0x01            ; Number of sectors to read
    mov cl, 0x02            ; Sector number (starts at 1, so 2 is the second sector)

    call read_disk
    call switch_to_protected_mode

    jmp $

read_disk:
    mov ah, 0x02             ; BIOS read sectors function
    mov ch, 0x00             ; Cylinder 0
    mov dh, 0x00             ; Head 0
    int 0x13                 ; BIOS Disk interrupt
    jc .disk_error           ; Check carry flag for error
    ret

.disk_error:
    hlt

%include "./boot/protected_mode.asm"

times 479-($-$$) db 0           ; Limit the sector to 479 bytes
%include "./boot/gdt.asm"       ; Include the GDT definition here
boot_drive db 0x00              ; Padding byte for boot drive number
dw 0xAA55                       ; Boot signature and last 2 bytes of the first sector