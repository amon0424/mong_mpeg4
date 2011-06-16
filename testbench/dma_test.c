#include <stdio.h>
#include <stdlib.h>
#include <time.h>

volatile long *dma_srcaddr  = (long *) 0xb0300000;
volatile long *dma_dstaddr  = (long *) 0xb0300004;
volatile long *dma_other  = (long *) 0xb0300008;
volatile long *dma_stride  = (long *) 0xb030000C;
volatile long *dma_width  = (long *) 0xb0300010;

volatile long *mcomp_data  = (long *) 0xb0000000;

int stride = 16;
unsigned char block1[32] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0,
						    8, 9,10,11,12,13,14,15,16, 0, 0, 0, 0, 0, 0, 0};
unsigned char block2[32] = {0};

int
main(int argc, char **argv)
{
	
	*dma_srcaddr = (long *)block1;
	*dma_dstaddr = mcomp_data;
	*dma_stride = stride;
	*dma_width = 9;  
	*dma_other = (1 << 20) | (3 << 18) | (3 << 16) | ( 2 );
	

	while(block2[0] == 0);
}