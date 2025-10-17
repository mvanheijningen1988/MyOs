[BITS 16]
switch_to_protected_mode:
    lgdt [gdt_descriptor]       ; Load the GDT
    mov eax, cr0
    or al, 1                    ; Set the PE bit (bit 0) in CR
    mov cr0, eax                ; Enable protected mode

    jmp CODE_SEG:protected_mode_init ; Farjump to flush the prefetch queue  

[BITS 32]
protected_mode_init:
    mov ax, DATA_SEG            ; Load data segment selector
    mov ds, ax                  ; Set DS
    mov ss, ax                  ; Set SS
    mov es, ax                  ; Set ES
    mov fs, ax                  ; Set FS
    mov gs, ax                  ; Set GS
    
    mov ebp, 0x90000            ; Set up stack base pointer
    mov esp, ebp                ; Set up stack pointer

    call main                   ; Call the main kernel function