# Global Descriptor Table (GDT)

The Global Descriptor Table (GDT) is a data structure used in x86 architecture to define memory segments and their properties in protected mode.

## GDT Structure

The GDT is an array of 8-byte segment descriptors. Each descriptor defines a memory segment's properties.

### Segment Descriptor Format (8 bytes)

A segment descriptor consists of the following fields:

```
Bits 0-15:    Limit (bits 0-15)
Bits 16-31:   Base Address (bits 0-15)
Bits 32-39:   Base Address (bits 16-23)
Bits 40-47:   Access Byte
Bits 48-51:   Limit (bits 16-19)
Bits 52-55:   Flags
Bits 56-63:   Base Address (bits 24-31)
```

## Access Byte (Bits 40-47)

| Bit | Name | Description |
|-----|------|-------------|
| 7 | P (Present) | Must be 1 for valid segments |
| 6-5 | DPL (Descriptor Privilege Level) | Ring level (0-3), 0 = kernel, 3 = user |
| 4 | S (Descriptor Type) | 0 = system, 1 = code/data |
| 3 | E (Executable) | 1 = code segment, 0 = data segment |
| 2 | DC (Direction/Conforming) | For data: 0 = grows up, 1 = grows down<br>For code: 0 = only executable from DPL, 1 = executable from equal or lower privilege |
| 1 | RW (Readable/Writable) | For code: 1 = readable<br>For data: 1 = writable |
| 0 | A (Accessed) | Set by CPU when segment is accessed |

## Flags (Bits 52-55)

| Bit | Name | Description |
|-----|------|-------------|
| 3 | G (Granularity) | 0 = limit in bytes, 1 = limit in 4KB blocks |
| 2 | DB (Size) | 0 = 16-bit segment, 1 = 32-bit segment |
| 1 | L (Long Mode) | 1 = 64-bit code segment, 0 = not 64-bit |
| 0 | Reserved | Always 0 |

## Common Segment Types

### Null Descriptor (Entry 0)
- Must be all zeros
- Required by CPU specification

### Kernel Code Segment
- Base: 0x00000000
- Limit: 0xFFFFF
- Access: 0x9A (Present, Ring 0, Code, Execute/Read)
- Flags: 0xC (Granularity 4KB, 32-bit)

### Kernel Data Segment
- Base: 0x00000000
- Limit: 0xFFFFF
- Access: 0x92 (Present, Ring 0, Data, Read/Write)
- Flags: 0xC (Granularity 4KB, 32-bit)

### User Code Segment
- Base: 0x00000000
- Limit: 0xFFFFF
- Access: 0xFA (Present, Ring 3, Code, Execute/Read)
- Flags: 0xC (Granularity 4KB, 32-bit)

### User Data Segment
- Base: 0x00000000
- Limit: 0xFFFFF
- Access: 0xF2 (Present, Ring 3, Data, Read/Write)
- Flags: 0xC (Granularity 4KB, 32-bit)

## Assembly Code Examples

### Complete GDT Setup and Loading

```assembly
[BITS 16]

; GDT Definition
gdt_start:
    ; Null descriptor (required first entry)
    dd 0x00000000
    dd 0x00000000

gdt_code:
    ; Kernel Code Segment (0x08)
    ; Base: 0x00000000, Limit: 0xFFFFF
    ; Access: 0x9A (Present, Ring 0, Code, Execute/Read)
    ; Flags: 0xC (4KB granularity, 32-bit)
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 0x9A         ; Access byte
    db 0xCF         ; Flags (4 bits) + Limit (bits 16-19)
    db 0x00         ; Base (bits 24-31)

gdt_data:
    ; Kernel Data Segment (0x10)
    ; Base: 0x00000000, Limit: 0xFFFFF
    ; Access: 0x92 (Present, Ring 0, Data, Read/Write)
    ; Flags: 0xC (4KB granularity, 32-bit)
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 0x92         ; Access byte
    db 0xCF         ; Flags (4 bits) + Limit (bits 16-19)
    db 0x00         ; Base (bits 24-31)

gdt_end:

; GDT Descriptor (6 bytes)
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of GDT - 1
    dd gdt_start                ; Linear address of GDT
```

### Loading GDT and Entering Protected Mode

```assembly
enter_protected_mode:
    cli                         ; Disable interrupts
    lgdt [gdt_descriptor]       ; Load GDT
    
    ; Enable protected mode
    mov eax, cr0
    or al, 1                    ; Set PE bit (bit 0)
    mov cr0, eax
    
    ; Far jump to flush instruction pipeline and load CS
    jmp 0x08:protected_mode_entry

[BITS 32]
protected_mode_entry:
    ; Now in 32-bit protected mode
    ; Load segment registers with data segment selector
    mov ax, 0x10                ; Data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    ; Set up stack pointer
    mov esp, 0x90000            ; Stack at 576KB
    
    ; Protected mode code continues here...
```

### Alternative GDT Using Macros (More Readable)

```assembly
; Macro for creating GDT entries
%macro gdt_entry 4
    ; %1 = base, %2 = limit, %3 = access, %4 = flags
    dw (%2 & 0xFFFF)           ; Limit low
    dw (%1 & 0xFFFF)           ; Base low
    db ((%1 >> 16) & 0xFF)     ; Base middle
    db %3                       ; Access byte
    db ((%4 << 4) | ((%2 >> 16) & 0x0F))  ; Flags + Limit high
    db ((%1 >> 24) & 0xFF)     ; Base high
%endmacro

gdt_start:
    gdt_entry 0, 0, 0, 0                    ; Null descriptor
    gdt_entry 0, 0xFFFFF, 0x9A, 0xC         ; Code segment
    gdt_entry 0, 0xFFFFF, 0x92, 0xC         ; Data segment
    gdt_entry 0, 0xFFFFF, 0xFA, 0xC         ; User code segment
    gdt_entry 0, 0xFFFFF, 0xF2, 0xC         ; User data segment
gdt_end:
```

### GDT with Task State Segment (TSS)

```assembly
gdt_start:
    ; Null descriptor
    dd 0x00000000, 0x00000000
    
    ; Kernel code segment
    dd 0x0000FFFF, 0x00CF9A00
    
    ; Kernel data segment  
    dd 0x0000FFFF, 0x00CF9200
    
    ; TSS descriptor (for hardware task switching)
    ; Base: address of TSS, Limit: size of TSS - 1
    ; Access: 0x89 (Present, Ring 0, TSS Available)
    dw tss_end - tss_start - 1  ; Limit low
    dw tss_start & 0xFFFF       ; Base low
    db (tss_start >> 16) & 0xFF ; Base middle
    db 0x89                     ; Access: TSS Available
    db 0x00                     ; Flags + Limit high
    db (tss_start >> 24) & 0xFF ; Base high
gdt_end:

; Task State Segment structure
tss_start:
    dd 0    ; Previous task link
    dd 0    ; ESP0 (kernel stack pointer)
    dd 0x10 ; SS0 (kernel stack segment)
    ; ... more TSS fields
tss_end:
```

## Loading the GDT

The GDT is loaded using the `lgdt` instruction with a GDT descriptor pointer:

```assembly
lgdt [gdt_descriptor]
```

The GDT descriptor is a 6-byte structure:
- Bytes 0-1: Size of GDT - 1
- Bytes 2-5: Linear address of GDT

## Segment Selectors and Addressing

### Segment Selector Format (16 bits)

```
Bits 0-1:  RPL (Requested Privilege Level)
Bit 2:     TI (Table Indicator) - 0 = GDT, 1 = LDT
Bits 3-15: Index into descriptor table
```

### Assembly Examples of Segment Usage

```assembly
; Loading segment selectors
mov ax, 0x08        ; Code segment selector (index 1, GDT, Ring 0)
mov ds, ax          ; Load data segment
mov es, ax          ; Load extra segment

; Far calls using segment selectors
call 0x08:function_address    ; Call function in code segment
jmp 0x08:new_location        ; Jump to code segment

; User mode segment selectors (Ring 3)
mov ax, 0x1B        ; User code: index 3, GDT, Ring 3 (0x18 | 3)
mov bx, 0x23        ; User data: index 4, GDT, Ring 3 (0x20 | 3)
```

### Real-World Bootloader Example

```assembly
[BITS 16]
org 0x7C00

start:
    cli                         ; Clear interrupts
    xor ax, ax                  ; Clear ax
    mov ds, ax                  ; Set data segment to 0
    mov es, ax                  ; Set extra segment to 0
    mov ss, ax                  ; Set stack segment to 0
    mov sp, 0x7C00              ; Set stack pointer
    
    lgdt [gdt_descriptor]       ; Load the GDT
    
    ; Enable protected mode
    mov eax, cr0
    or al, 1                    ; Set PE bit
    mov cr0, eax
    
    ; Far jump to 32-bit code
    jmp 0x08:protected_start

[BITS 32]
protected_start:
    ; Set up segment registers
    mov ax, 0x10                ; Data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000            ; Set stack pointer
    
    ; Your 32-bit kernel code here
    mov eax, 0xB8000            ; VGA text buffer
    mov [eax], word 0x0741      ; Write 'A' with gray on black
    
    hlt                         ; Halt

; GDT definition
gdt_start:
    ; Null descriptor
    dq 0
    
    ; Code segment (0x08)
    dw 0xFFFF, 0x0000           ; Limit, Base low
    db 0x00, 0x9A, 0xCF, 0x00   ; Base mid, Access, Flags+Limit high, Base high
    
    ; Data segment (0x10)  
    dw 0xFFFF, 0x0000           ; Limit, Base low
    db 0x00, 0x92, 0xCF, 0x00   ; Base mid, Access, Flags+Limit high, Base high
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size
    dd gdt_start                ; Offset

times 510-($-$$) db 0           ; Pad to 510 bytes
dw 0xAA55                       ; Boot signature
```

## Memory Protection Examples

### Checking Segment Limits

```assembly
; Example: Protected mode memory access
mov eax, 0x12345678     ; Some address
mov [eax], byte 0x42    ; Write to memory
; If eax exceeds segment limit, CPU generates General Protection Fault
```

### Privilege Level Transitions

```assembly
; Kernel to User mode transition (Ring 0 to Ring 3)
push 0x23               ; User data segment (Ring 3)
push user_stack         ; User stack pointer
pushf                   ; Push flags
push 0x1B               ; User code segment (Ring 3)  
push user_entry_point   ; User code entry point
iret                    ; Interrupt return to user mode
```

## Impact on System Behavior

- **Privilege Levels (DPL)**: Control access to segments, enabling kernel/user mode separation
- **Granularity**: Determines maximum addressable memory (4GB with 4KB granularity)
- **Size Flag**: Switches between 16-bit and 32-bit operation modes
- **Segment Limits**: Provide memory protection by restricting access beyond defined boundaries
- **Base Address**: Allows mapping segments to different physical memory locations (flat model uses base 0)