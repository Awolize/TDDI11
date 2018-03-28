OBJ    = main.o
COURSE   = /home/TDDI11/sw
LDSCRIPT = $(COURSE)/lib/link.cmd
BOOTSECT = $(COURSE)/lib/bootload.bin
INCLUDES = -I "$(COURSE)/include" -I "$(COURSE)/include/djgpp" $(EXTRA_INCLUDES)
CC       = /sw/i386-elf-gcc-4.9.0/bin/i386-elf-gcc-4.9.0
CFLAGS  += -Wall -g $(INCLUDES)
LD       = /sw/i386-elf-gcc-4.9.0/bin/i386-elf-ld
LDFLAGS  = -T$(LDSCRIPT) -static -ustart -Map link.map

embedded.bin: $(OBJ)
	$(LD) $(OBJ) $(LIBS) $(LDFLAGS)
%.o: %.c
	$(CC) $(CFLAGS) -c $<
clean:
	\rm -f link.map embedded.bin *~ *.o 
