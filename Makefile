# Copyright (c) 2004, All Right Reserved
#
# Multimedia Embedded Systems Lab
# Dept. Computer Science and Information Engineering
# National Chiao Tung University
# Hsinchu, 300, Taiwan
#

ECOSDIR=../../ecos_leon/leon_install
SPARCTOOLS=/opt/sparc-elf-3.4.4/bin

CFLAGS=-Wall -O2 -D__ECOS -D_PROFILING_ -I$(ECOSDIR)/include \
       -ggdb -DARCH_IS_BIG_ENDIAN -msoft-float
LFLAGS=-Ttarget.ld -nostdlib -L$(ECOSDIR)/lib \
       -ggdb -DARCH_IS_BIG_ENDIAN -msoft-float

CC= $(SPARCTOOLS)/sparc-elf-gcc
LD= $(SPARCTOOLS)/sparc-elf-ld
ST= $(SPARCTOOLS)/sparc-elf-strip

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

OBJS=src/bilinear8x8.o src/bitstream.o src/idct.o src/image.o \
     src/m4vdec_api.o src/mbcoding.o src/mbprediction.o src/mem_align.o \
     src/mem_transfer.o src/quant_h263.o src/timer.o

# Put your application build procedure here

APPNAME = m4v_dec

$(APPNAME):  src/$(APPNAME).o $(OBJS)
	$(CC) $(LFLAGS) -o $@.elf src/$@.o $(OBJS)

timer_example:  timer_example.c
	$(CC) $(CFLAGS) $(LFLAGS) -o timer_example.elf timer_example.c

clean:
	rm src/*.o
	rm *.elf
