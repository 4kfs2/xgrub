AS := i386-elf-as
LD := i386-elf-ld
CC := i386-elf-gcc
CFLAGS := -ffreestanding -Wall -Wextra -nostdlib
bin := boot.bin kernel.bin

%.bin : %.o
	$(LD) -Ttext 0 --oformat=binary -o $@ $< 

all : com.bin

kernel.bin : kernel.o main.o
	$(LD) -Ttext 0 --oformat=binary -o $@ $^

com.bin : $(bin)
	cat $^ > $@

clean :
	$(RM) *.o *.bin