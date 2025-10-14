# x86 and x86-64 Registers

This document provides a comprehensive breakdown of x86 and x86-64 registers, including their 64-bit, 32-bit, 16-bit, and 8-bit components, along with their purposes.

---

## General-Purpose Registers

| **Register** | **Size** | **Sub-Registers**       | **Purpose**                                                                 |
|--------------|----------|-------------------------|-----------------------------------------------------------------------------|
| **RAX**      | 64-bit   | `EAX` (32-bit), `AX` (16-bit), `AH` (high 8-bit), `AL` (low 8-bit) | Accumulator register. Used for arithmetic, I/O operations, and function return values. |
| **RBX**      | 64-bit   | `EBX` (32-bit), `BX` (16-bit), `BH` (high 8-bit), `BL` (low 8-bit) | Base register. Often used for memory addressing.                             |
| **RCX**      | 64-bit   | `ECX` (32-bit), `CX` (16-bit), `CH` (high 8-bit), `CL` (low 8-bit) | Counter register. Used for loops, shifts, and string operations.             |
| **RDX**      | 64-bit   | `EDX` (32-bit), `DX` (16-bit), `DH` (high 8-bit), `DL` (low 8-bit) | Data register. Used for I/O operations, division, and passing arguments.     |
| **RSI**      | 64-bit   | `ESI` (32-bit), `SI` (16-bit), `SIL` (low 8-bit)                  | Source index. Used for string operations and memory addressing.              |
| **RDI**      | 64-bit   | `EDI` (32-bit), `DI` (16-bit), `DIL` (low 8-bit)                  | Destination index. Used for string operations and memory addressing.         |
| **RBP**      | 64-bit   | `EBP` (32-bit), `BP` (16-bit), `BPL` (low 8-bit)                 | Base pointer. Used to reference function parameters and local variables.     |
| **RSP**      | 64-bit   | `ESP` (32-bit), `SP` (16-bit), `SPL` (low 8-bit)                 | Stack pointer. Points to the top of the stack.                               |

---

## Special-Purpose Registers

| **Register** | **Size** | **Sub-Registers**       | **Purpose**                                                                 |
|--------------|----------|-------------------------|-----------------------------------------------------------------------------|
| **RIP**      | 64-bit   | `EIP` (32-bit), `IP` (16-bit)                              | Instruction pointer. Points to the next instruction to execute.             |
| **FLAGS**    | 16-bit   | `EFLAGS` (32-bit), `RFLAGS` (64-bit)                       | Flags register. Stores CPU status flags (e.g., carry, zero, sign).          |

---

## Segment Registers

| **Register** | **Size** | **Purpose**                                                                 |
|--------------|----------|-----------------------------------------------------------------------------|
| **CS**       | 16-bit   | Code segment. Points to the segment containing the currently executing code. |
| **DS**       | 16-bit   | Data segment. Points to the segment containing data.                        |
| **ES**       | 16-bit   | Extra segment. Often used for string operations.                            |
| **FS**       | 16-bit   | General-purpose segment register.                                           |
| **GS**       | 16-bit   | General-purpose segment register.                                           |
| **SS**       | 16-bit   | Stack segment. Points to the segment containing the stack.                  |

### Address Calculations with Segment Registers

In x86 architecture, segment registers are used to calculate physical addresses from logical addresses. The calculation method depends on the CPU mode:

#### Real Mode (16-bit)
In real mode, physical addresses are calculated using the formula:
```
Physical Address = (Segment Register × 16) + Offset
```

**Example:**
- If `DS = 0x1000` and offset = `0x0050`
- Physical Address = `(0x1000 × 16) + 0x0050 = 0x10000 + 0x0050 = 0x10050`

#### Protected Mode (32-bit)
In protected mode, segment registers contain **selectors** that point to entries in descriptor tables:
```
Physical Address = Base Address (from descriptor) + Offset
```

**Selector Format (16-bit):**
```
Bits 15-3: Index into descriptor table
Bit 2:     Table Indicator (0 = GDT, 1 = LDT)
Bits 1-0:  Requested Privilege Level (RPL)
```

#### Long Mode (64-bit)
In 64-bit mode, segmentation is mostly disabled:
- `CS`, `DS`, `ES`, `SS` are treated as having base = 0 and limit = 0xFFFFFFFF
- `FS` and `GS` can still have non-zero base addresses for special purposes
- Linear address = effective address (no segment offset added)

#### Common Segment:Offset Notation
When writing assembly code, addresses are often written as `segment:offset`:
- `0x1000:0x0050` represents segment 0x1000, offset 0x0050
- In real mode: physical address = `0x10050`
- `CS:IP` points to the current instruction
- `SS:SP` points to the top of the stack
- `DS:SI` commonly used for source data
- `ES:DI` commonly used for destination data

---

## Control Registers (64-bit Mode Only)

| **Register** | **Purpose**                                                                 |
|--------------|-----------------------------------------------------------------------------|
| **CR0**      | Controls the operating mode of the CPU (e.g., enabling protected mode).     |
| **CR2**      | Contains the page fault linear address.                                     |
| **CR3**      | Contains the physical address of the page directory (used in paging).       |
| **CR4**      | Controls additional CPU features (e.g., enabling PAE, SSE instructions).    |

---

## Debug Registers

| **Register** | **Purpose**                                                                 |
|--------------|-----------------------------------------------------------------------------|
| **DR0**-`DR3`| Debug address registers. Store the addresses of breakpoints.               |
| **DR6**      | Debug status register. Indicates which breakpoint was hit.                 |
| **DR7**      | Debug control register. Enables or disables breakpoints.                  |

---

## Floating-Point and SIMD Registers

| **Register** | **Size** | **Purpose**                                                                 |
|--------------|----------|-----------------------------------------------------------------------------|
| **ST(0)**-`ST(7)` | 80-bit | Floating-point registers for x87 FPU operations.                       |
| **XMM0**-`XMM15`  | 128-bit | SIMD registers for SSE instructions.                                   |
| **YMM0**-`YMM15`  | 256-bit | Extended SIMD registers for AVX instructions.                         |
| **ZMM0**-`ZMM31`  | 512-bit | Extended SIMD registers for AVX-512 instructions.                     |

---

## Summary of Register Components

| **Register** | **64-bit** | **32-bit** | **16-bit** | **High 8-bit** | **Low 8-bit** | **Purpose**                                                                 |
|--------------|------------|------------|------------|----------------|---------------|-----------------------------------------------------------------------------|
| **RAX**      | `RAX`      | `EAX`      | `AX`       | `AH`           | `AL`          | Accumulator register for arithmetic and I/O operations.                    |
| **RBX**      | `RBX`      | `EBX`      | `BX`       | `BH`           | `BL`          | Base register for memory addressing.                                       |
| **RCX**      | `RCX`      | `ECX`      | `CX`       | `CH`           | `CL`          | Counter register for loops and shifts.                                     |
| **RDX**      | `RDX`      | `EDX`      | `DX`       | `DH`           | `DL`          | Data register for I/O and division.                                        |
| **RSI**      | `RSI`      | `ESI`      | `SI`       | -              | `SIL`         | Source index for string operations.                                        |
| **RDI**      | `RDI`      | `EDI`      | `DI`       | -              | `DIL`         | Destination index for string operations.                                   |
| **RBP**      | `RBP`      | `EBP`      | `BP`       | -              | `BPL`         | Base pointer for stack frames.                                             |
| **RSP**      | `RSP`      | `ESP`      | `SP`       | -              | `SPL`         | Stack pointer for stack operations.                                        |

---

Let me know if you need further clarification or additional details!