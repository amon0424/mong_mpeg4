# Copyright (c) 2008, All Right Reserved
#
# Multimedia Embedded Systems Lab
# Dept. Computer Science and Information Engineering
# National Chiao Tung University
# Hsinchu, 300, Taiwan
#

SPARCTOOLS=/opt/sparc-elf-3.4.4/bin
CFLAGS=
LFLAGS=

CC=$(SPARCTOOLS)/sparc-elf-gcc
LD=$(SPARCTOOLS)/sparc-elf-ld
OC=$(SPARCTOOLS)/sparc-elf-objcopy

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

# Put your application build procedure here

APPNAME = mcomp_tb

$(APPNAME):  $(APPNAME).o $(OBJS)
	$(CC) $(LFLAGS) -o $@.elf $@.o
	$(OC) -O srec $@.elf sdram.srec

clean:
	rm *.o
	rm *.elf
	rm *.srec
