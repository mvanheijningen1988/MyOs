# INT 13h Error Codes

The BIOS interrupt `INT 13h` is used for disk services, such as reading and writing sectors. 

## Register Usage

### Input Registers (before calling INT 13h):

| Register | Purpose | Description |
|----------|---------|-------------|
| `AH` | Function Number | Specifies the operation to perform |
| `AL` | Sector Count | Number of sectors to read/write (1-128) |
| `CH` | Cylinder (Low) | Lower 8 bits of cylinder number (0-1023) |
| `CL` | Sector + Cylinder (High) | Bits 0-5: Sector number (1-63, 1-based!)<br>Bits 6-7: Upper 2 bits of cylinder number |
| `DH` | Head Number | Head/side number (0-255) |
| `DL` | Drive Number | 0x00-0x7F: Floppy drives<br>0x80-0xFF: Hard drives (0x80 = first HDD) |
| `ES:BX` | Buffer Address | Memory location for data transfer |

### Common Function Numbers (AH):
- `0x00` = Reset disk system
- `0x01` = Get disk status  
- `0x02` = Read sectors
- `0x03` = Write sectors
- `0x08` = Get drive parameters

### Output Registers (after INT 13h returns):

| Register | Purpose | Description |
|----------|---------|-------------|
| `CF` | Carry Flag | 0 = Success, 1 = Error occurred |
| `AH` | Status/Error Code | 0x00 = Success, other values = error codes (see table below) |
| `AL` | Sectors Transferred | Number of sectors actually processed (on success) |

## Error Codes

When an error occurs, the carry flag (CF) is set, and an error code is returned in the `AH` register. Below is a list of possible error codes and their meanings:

| Error Code (Hex) | Description                                   |
|-------------------|-----------------------------------------------|
| `00h`            | No error (operation successful).             |
| `01h`            | Invalid function or parameter.               |
| `02h`            | Address mark not found.                      |
| `03h`            | Disk write-protected.                        |
| `04h`            | Sector not found or out of range.            |
| `05h`            | Reset failed (controller error).             |
| `06h`            | Disk changed (media change detected).        |
| `07h`            | Drive parameter activity failed.             |
| `08h`            | DMA overrun (DMA boundary error).            |
| `09h`            | Data boundary error (attempt to read/write beyond the end of the disk). |
| `0Ah`            | Bad sector detected.                         |
| `0Bh`            | Bad track detected.                          |
| `0Ch`            | Unsupported track or invalid media.          |
| `0Dh`            | Invalid number of sectors on format.         |
| `0Eh`            | Control data address mark detected.          |
| `0Fh`            | DMA arbitration level out of range.          |
| `10h`            | Uncorrectable CRC or ECC error on read.      |
| `11h`            | Data ECC corrected, but data may be suspect. |
| `20h`            | Controller failure.                          |
| `31h`            | No media in drive.                           |
| `32h`            | Incorrect drive type.                        |
| `40h`            | Seek failed.                                 |
| `80h`            | Timeout (device not responding).             |
| `AAh`            | Drive not ready.                             |
| `B0h`            | Volume not locked in drive.                  |
| `B1h`            | Volume locked in drive.                      |
| `B2h`            | Volume not removable.                        |
| `B3h`            | Volume in use.                               |
| `B4h`            | Lock count exceeded.                         |
| `B5h`            | Invalid lock/unlock command.                 |
| `B6h`            | Invalid disk change.                         |
| `BBh`            | Undefined error.                             |
| `C0h`            | Bad request structure length.                |
| `FFh`            | Sense operation failed.                      |

### Notes:
- These error codes are returned in the `AH` register after a failed `INT 13h` operation.
- Always check the carry flag (CF) to determine if an error occurred.
- Sector numbers in `CL` are 1-based (sectors 1-63), not 0-based.
- The `ES:BX` registers must point to a valid memory location for data transfer.
- Some error codes may vary depending on the BIOS implementation.