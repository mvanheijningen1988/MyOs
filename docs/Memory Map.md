# MyOS Memory Map

This document describes the memory layout for MyOS in its current bootloader-only state.

---

## Real Mode Memory Map (First 1MB)
```
Physical Address Range      Size        Description
======================      ====        ===========
0x00000000 - 0x000003FF     1KB         Interrupt Vector Table (IVT)
0x00000400 - 0x000004FF     256B        BIOS Data Area (BDA)
0x00000500 - 0x00007BFF     ~30KB       Conventional Memory (free)
0x00007C00 - 0x00007DFF     512B        Boot Sector (our bootloader)
0x00007E00 - 0x0007FFFF     ~480KB      Conventional Memory (free)
0x00080000 - 0x0009FFFF     128KB       Extended BIOS Data Area (EBDA)
0x000A0000 - 0x000BFFFF     128KB       Video Display Memory
0x000C0000 - 0x000F7FFF     224KB       Video BIOS and Adapter ROMs
0x000F8000 - 0x000FFFFF     32KB        System BIOS
```

## Current Memory Layout (Real Mode - 16-bit)

```
Physical Address    Size    Description
================    ====    ===========
0x7C00 - 0x7DFF     512B    Boot sector
```

### Boot Sector Memory Layout
```
Physical Address    Size    Description
================    ====    ===========
0x7C00 - 0x7DFC     509B    Bootloader code  
0x7DFD - 0x7DFD     1B      Boot drive number storage
0x7DFE - 0x7DFF     2B      Boot signature (0xAA55)
```

*This memory map reflects the current state of MyOS bootloader and will be updated as the OS grows.*