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

int stride = 32;
/*	
	source, h(r=1)
	0,  1,  2,  3,  4,  5,  6,  7,
	0,  9,  A,  B,  C,  D,  E,  F,
	0, 11, 12, 13, 14, 15, 16, 17, 
	...
	39, 3A, 3B, 3C, 3D, 3E, 3F, 40

	h(r=1)
	0,  1,  2,  3,  4,  5,  6,  7,
	4,  9,  A,  B,  C,  D,  E,  F,
	8, 11, 12, 13, 14, 15, 16, 17, 
	...
	1C, 39, 3A, 3B, 3C, 3D, 3E, 3F

	v(r=1)
	0,  5,  6,  7,  8,  9,  A,  B,
	0,  D,  E,  F, 10, 11, 12, 13,
	0, 15, 16, 17, 18, 19, 1A, 1B,
	...
	0, 3D, 3E, 3F, 40, 41, 42, 43
*/
unsigned char block1[32*9] = {0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,9,10,11,12,13,14,15,16,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,33,34,35,36,37,38,39,40,41,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,41,42,43,44,45,46,47,48,49,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,49,50,51,52,53,54,55,56,57,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,57,58,59,60,61,62,63,64,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
							0,65,66,67,68,69,70,71,72,73,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
unsigned char block2[32*9] = {0};
unsigned char block3[32*9] = {0};
int
main(int argc, char **argv)
{
	int idx, row;

	// halfpel8x8_h
	*dma_srcaddr = &(block1[0]);
	*dma_dstaddr = mcomp_data;
	*dma_src_stride = stride;
	*dma_src_width = 9;  
	//*dma_dst_stride = 8;
	*dma_dst_width = 8;  
	*dma_r = (0 << 30) | 1;
	*dma_other = (1 << 20) | (2 << 18) | (2 << 16) | ( 2 );
	
	while((*dma_other) >> 20);

	*dma_srcaddr = mcomp_data;
	*dma_dstaddr = &(block2[0]);
	*dma_dst_stride = stride;
	*dma_src_stride = 0;
	*dma_src_width = 8;  
	*dma_other = (0x3 << 20) | (2 << 18) | (2 << 16) | ( 2 );
	
	while((*dma_other) >> 20);

	//printf("h: %#x %#x %#x~%#x %#x\n%#x %#x %#x~%#x %#x\n", block2[0], block2[1], block2[2], block2[6], block2[7], block2[stride], block2[stride+1], block2[stride+2], block2[stride+6], block2[stride+7]);

	// halfpel8x8_v
	*dma_srcaddr = &(block1[0]);
	*dma_dstaddr = mcomp_data;
	*dma_src_stride = stride;
	*dma_src_width = 9;  
	*dma_dst_stride = 0;
	*dma_dst_width = 8;  
	*dma_r = (1 << 30) | 1;
	*dma_other = (1 << 20) | (2 << 18) | (2 << 16) | ( 2 );
	
	while((*dma_other) >> 20);

	*dma_srcaddr = mcomp_data;
	*dma_dstaddr = &(block3[0]);
	*dma_dst_stride = stride;
	*dma_src_stride = 0;
	*dma_src_width = 8;  
	*dma_other = (0x3 << 20) | (2 << 18) | (2 << 16) | ( 2 );
	
	while((*dma_other) >> 20);

	idx = 0;
	printf("Results of halfpel8x8_h = [\n");
    for (row = 0; row < 8; row++)
    {
        printf("%#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x\n", block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++] );
    }
    printf("]\n");

	idx = 0;
	printf("Results of halfpel8x8_v = [\n");
    for (row = 0; row < 8; row++)
    {
        printf("%#x, %#x, %#x, %#x, %#x, %#x, %#x, %#x\n", block3[idx++], block3[idx++], block3[idx++], block3[idx++], block3[idx++], block3[idx++], block3[idx++], block3[idx++] );
    }
    printf("]\n");
}