AS := nasm
CC := i386-elf-gcc
CFLAGS := -ffreestanding -Wall -Wextra -nostdlib
bin := boot.bin kernel.bin

%.bin : %.asm
	$(AS) -f bin -o $@ $<

all : com.bin

com.bin : $(bin)
	cat $^ > $@

clean :
	$(RM) *.o *.bin