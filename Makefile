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
OUT_DIR = out
QEMU = qemu-system-i386

# Default target
all: directory boot.bin hd.img burn

directory:
	mkdir -p $(OUT_DIR)

# Compile boot.asm to boot.bin
boot.bin: boot/boot.asm
	$(ASM) $(ASM_FLAGS) $< -o $(OUT_DIR)/$@

hd.img:
	dd if=/dev/zero of=$(OUT_DIR)/$@ bs=512 count=2880
	mkfs.ext2 -v $(OUT_DIR)/$@

burn: boot.bin hd.img
	dd if=$(OUT_DIR)/boot.bin of=$(OUT_DIR)/hd.img conv=notrunc

run: 
	$(QEMU) -drive format=raw,file=$(OUT_DIR)/hd.img,if=ide --monitor stdio

debug:
	$(QEMU) -s -S -drive format=raw,file=$(OUT_DIR)/hd.img,if=ide --monitor stdio

# Clean build artifacts
clean:
	rm -rdf $(OUT_DIR)/
	rm -f memdump.bin

# Phony targets
.PHONY: all clean