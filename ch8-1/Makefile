AS := nasm
CC := i386-elf-gcc
CFLAGS := -ffreestanding -Wall -Wextra -nostdlib
bin := boot.bin setup.bin kernel_paging.bin user_program1.bin user_program2.bin user_program3.bin \
		user_program4.bin user_program5.bin

%.bin : %.asm
	$(AS) -f bin -o $@ $<

all : com.bin

com.bin : $(bin)
	cat $^ > $@

clean :
	$(RM) *.o *.bin