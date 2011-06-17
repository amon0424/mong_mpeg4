#include <stdio.h>
#include <stdlib.h>
#include <time.h>

volatile long *dma_srcaddr  = (long *) 0xb0300000;
volatile long *dma_dstaddr  = (long *) 0xb0300004;
volatile unsigned long *dma_other  = (long *) 0xb0300008;
volatile long *dma_src_stride  = (long *) 0xb030000C;
volatile long *dma_src_width  = (long *) 0xb0300010;
volatile long *dma_dst_stride  = (long *) 0xb0300014;
volatile long *dma_dst_width  = (long *) 0xb0300018;
volatile long *dma_r  = (long *) 0xb030001C;

volatile long *mcomp_data  = (long *) 0xb0000000;
//volatile long *mcomp_r  = (long *) 0xb0000080;

int stride = 16;
/* h
	
*/
unsigned char block1[32] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0,
						    8, 9,10,11,12,13,14,15,16, 0, 0, 0, 0, 0, 0, 0};
unsigned char block2[32] = {0};

int
main(int argc, char **argv)
{
	
	*dma_srcaddr = (long *)block1;
	*dma_dstaddr = mcomp_data;
	*dma_src_stride = stride;
	*dma_src_width = 9;  
	*dma_dst_stride = 8;
	*dma_dst_width = 8;  
	*dma_r = 1;
	*dma_other = (1 << 20) | (2 << 18) | (2 << 16) | ( 2 );
	
	while((*dma_other) >> 20);

	*dma_srcaddr = mcomp_data;
	*dma_dstaddr = (long *)block1;
	*dma_dst_stride = stride;
	*dma_src_stride = 8;
	*dma_src_width = 8;  
	*dma_other = (1 << 20) | (2 << 18) | (2 << 16) | ( 2 );
	
	while(block2[0] == 0);
}