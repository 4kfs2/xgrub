AS := i686-elf-as
LD := i686-elf-ld

bin := boot.bin kernel.bin

%.bin : %.o
	$(LD) -Ttext 0 --oformat=binary -o $@ $< 

com.bin : $(bin)
	cat $^ > $@

clean :
	$(RM) *.o *.bin