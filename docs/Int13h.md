# INT 13h Error Codes

The BIOS interrupt `INT 13h` is used for disk services, such as reading and writing sectors. When an error occurs, the carry flag (CF) is set, and an error code is returned in the `AH` register. Below is a list of possible error codes and their meanings:

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
- Some error codes may vary depending on the BIOS implementation.