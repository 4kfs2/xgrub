AS := i686-elf-as
LD := i686-elf-ld
CC := i686-elf-gcc
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