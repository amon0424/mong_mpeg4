#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TEST_BOUNDARY 0

volatile long *dma_srcaddr  = (long *) 0xb0300000;
volatile long *dma_dstaddr  = (long *) 0xb0300004;
volatile long *dma_address_options  = (long *) 0xb0300008;
volatile unsigned long *dma_action  = (long *) 0xb030000C;

//volatile long *dma_mcomp_args  = (long *) 0xb030001C;

volatile long *mcomp_data  = (long *) 0xb0000000;
//volatile long *mcomp_r  = (long *) 0xb0000080;
	
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

	hv(r=2)
	 2, 5, 6, 7, 8, 9, A, B,
	 6, D, E, F,10,11,12,13,
	 A,15,16,17,18,19,1A,1B
	...
	1E,3D,3E,3F,40,41,42,43
*/
int stride = 32;
unsigned char block1[32*9] =   {0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,9,10,11,12,13,14,15,16,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,33,34,35,36,37,38,39,40,41,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,41,42,43,44,45,46,47,48,49,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,49,50,51,52,53,54,55,56,57,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,57,58,59,60,61,62,63,64,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,65,66,67,68,69,70,71,72,73,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
unsigned char block2[32*9] = {0};	// h
unsigned char block3[32*9] = {0};	// v
unsigned char block4[32*9] = {0};	// hv
int
main(int argc, char **argv)
{
	int idx, row;
	unsigned int src, dst;

#if TEST_BOUNDARY
	int alignOffset;
	int ALIGN_SIZE_SRC = 0X3F8;
	int ALIGN_SIZE_DST = 0X3FC;
	
	unsigned char *ptrSrc, *ptrDst;

	// get aligned address
	unsigned char* ptr_base_src = malloc( stride*9 + ALIGN_SIZE_SRC - 1 );
	unsigned char* ptr_base_dst = malloc( stride*9 + ALIGN_SIZE_DST - 1 );

	alignOffset = ((unsigned int)ptr_base_src ^ ALIGN_SIZE_SRC) & 0x3FF;
	ptrSrc = ptr_base_src + alignOffset;
	alignOffset = ((unsigned int)ptr_base_dst ^ ALIGN_SIZE_DST) & 0x3FF;
	ptrDst = ptr_base_dst + alignOffset;

	//unsigned char* ptr = ptr_base;
	
	// initialize source data
	unsigned char val;
	val = 1;
	idx=0;
	for (row = 0; row < (stride << 3) + stride; idx = (row += stride))
	{
		ptrSrc[idx] = 0;
		ptrSrc[idx+1] = val++;
		ptrSrc[idx+2] = val++;
		ptrSrc[idx+3] = val++;
		ptrSrc[idx+4] = val++;
		ptrSrc[idx+5] = val++;
		ptrSrc[idx+6] = val++;
		ptrSrc[idx+7] = val++;
		ptrSrc[idx+8] = val++;
		ptrSrc[idx+9] = val++;

		val--;
	}
	src = (unsigned int)(&ptrSrc[0]);
	dst = (unsigned int)(&ptrDst[0]);
	printf("align offset=%#x\n", alignOffset);
	printf("ptr_base=%#X\n", ptr_base);
	printf("ptr=%#X\n", ptr);
	idx = 0;
	printf("src = [\n");
    for (row = 0; row < 9; row++)
    {
        printf("%04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x: %04#x, %04#x\n", ptr[idx], ptr[idx+1], ptr[idx+2], ptr[idx+3], ptr[idx+4], ptr[idx+5], ptr[idx+6], ptr[idx+7], ptr[idx+8], ptr[idx+9] );
		idx += stride;
    }
    printf("]\n");
#else
	src = (unsigned int)block1;
	dst = (unsigned int)block2;
#endif
	
	// halfpel8x8_hv
	*dma_srcaddr = (unsigned int)&(block1[1]);
	//*dma_dstaddr = (unsigned int)&block2[0];
	*dma_dstaddr = dst;
	//                     offset      src stride       dst stride       mode     r
	*dma_address_options = (1 << 30) | (stride << 20) | (stride << 10) | (2<<8) | 2;
	*dma_action = 1;

	while(*dma_action);

	// halfpel8x8_h
	*dma_srcaddr = src;
	*dma_dstaddr = (unsigned int)block3;
	//                     offset      src stride       dst stride       mode     r
	*dma_address_options = (0 << 30) | (stride << 20) | (stride << 10) | (1<<8) | 1;
	
	*dma_action = 1;
	while(*dma_action);

	// halfpel8x8_v
	*dma_srcaddr = src;
	*dma_dstaddr = (unsigned int)block4;
	//                     offset      src stride       dst stride       mode     r
	*dma_address_options = (0 << 30) | (stride << 20) | (stride << 10) | (0<<8) | 1;

	*dma_action = 1;
	while(*dma_action);

	// print results
	idx = 0;
	printf("Results of halfpel8x8_hv = [\n");
    for (row = 0; row < 9; row++)
    {
        printf("%04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x: %04#x\n", block2[idx], block2[idx+1], block2[idx+2], block2[idx+3], block2[idx+4], block2[idx+5], block2[idx+6], block2[idx+7], block2[idx+8]  );
		idx += stride;
    }
    printf("]\n");

	idx = 0;
	printf("Results of halfpel8x8_h = [\n");
    for (row = 0; row < 9; row++)
    {
        printf("%04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x: %04#x\n", block3[idx], block3[idx+1], block3[idx+2], block3[idx+3], block3[idx+4], block3[idx+5], block3[idx+6], block3[idx+7], block3[idx+8] );
		idx += stride;
    }
    printf("]\n");

	idx = 0;
	printf("Results of halfpel8x8_v = [\n");
    for (row = 0; row < 9; row++)
    {
        printf("%04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x, %04#x: %04#x\n", block4[idx], block4[idx+1], block4[idx+2], block4[idx+3], block4[idx+4], block4[idx+5], block4[idx+6], block4[idx+7], block4[idx+8] );
		idx += stride;
    }
    printf("]\n");
#if 0	
	free(ptr_base_src);
	free(ptr_base_dst);
#endif
}
