#include "loader.h"

#define VGA_MEMORY 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

void main() {    
    // Halt the CPU
    while(1) {
        asm volatile ("hlt");
    }
}