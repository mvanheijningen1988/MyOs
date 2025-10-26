# Minimal Makefile for MyOS bootloader
# $@ = target
# $< = first dependency
# $^ = all dependencies
# $* = target without extension
# $? = newer than target
# $(@D) = target directory
# $(@F) = target file name
# $(@R) = target file name without extension
# $(@X) = target file name with extension

# Assembler configuration
ASM = nasm
ASM_FLAGS = -f bin
CC = x86_64-elf-gcc
CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -nodefaultlibs -fno-builtin -mno-sse -mno-sse2 -mpreferred-stack-boundary=2 -c
LD = x86_64-elf-ld
LDFLAGS = -m elf_i386 -T linker.ld --oformat binary
OUT_DIR = out
QEMU = qemu-system-i386

# Default target
all: directory boot.bin loader.bin hd.img burn

directory:
	mkdir -p $(OUT_DIR)

# Compile boot.asm to boot.bin
boot.bin: boot/boot.asm
	$(ASM) $(ASM_FLAGS) $< -o $(OUT_DIR)/$@

# Compile C loader
loader.o: stage2/loader.c
	$(CC) $(CFLAGS) $< -o $(OUT_DIR)/$@

# Link loader to flat binary at 0x500
loader.bin: loader.o
	$(LD) $(LDFLAGS) $(OUT_DIR)/loader.o -o $(OUT_DIR)/$@

hd.img:
	dd if=/dev/zero of=$(OUT_DIR)/$@ bs=512 count=2880

burn: boot.bin loader.bin hd.img
	dd if=$(OUT_DIR)/boot.bin of=$(OUT_DIR)/hd.img conv=notrunc bs=512 count=1 seek=0
	dd if=$(OUT_DIR)/loader.bin of=$(OUT_DIR)/hd.img conv=notrunc bs=512 count=2 seek=1

run: 
	$(QEMU) -drive format=raw,file=$(OUT_DIR)/hd.img,if=ide --monitor stdio

debug:
	$(QEMU) -s -S -drive format=raw,file=$(OUT_DIR)/hd.img,if=ide --monitor stdio

# Clean build artifacts
clean:
	rm -rdf $(OUT_DIR)/
	rm -f memdump.bin

# Phony targets
.PHONY: all clean directory