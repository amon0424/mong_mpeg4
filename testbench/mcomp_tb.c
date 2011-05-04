#include <stdio.h>
#include <string.h>
// 80 pixels 0xb0000000 ~ 0xb0000140

#define USE_HW_MC1 0
#define USE_HW_MC 1

#if USE_HW_MC
volatile int *pixels_base = (int *) 0xb0000000;
volatile int *reg_a  = (int *) 0xb0000000;
volatile int *reg_b  = (int *) 0xb0000004;
volatile int *reg_c  = (int *) 0xb0000008;
volatile int *reg_d  = (int *) 0xb000000c;
volatile int *reg_r  = (int *) 0xb0000144;
volatile int *reg_mode = (int *) 0xb0000148;
#elif USE_HW_MC1
volatile int *reg_a  = (int *) 0xb0000000;
volatile int *reg_b  = (int *) 0xb0000004;
volatile int *reg_c  = (int *) 0xb0000008;
volatile int *reg_d  = (int *) 0xb000000c;
volatile int *reg_r  = (int *) 0xb0000010;
volatile int *mc_2pt = (int *) 0xb000014C;
volatile int *mc_4pt = (int *) 0xb0000150;
#endif


int
main(int argc, char **argv)
{
	int i, idx;
	volatile int* ppixels;
	int val;

	int src[81] = 
		{209, 169, 123, 126, 167, 188, 197, 211,
		209, 169, 123, 126, 167, 188, 197, 211,
		209, 182, 169, 135, 128, 168, 199, 205,
		209, 195, 208, 171, 121, 132, 175, 200,
		209, 198, 212, 214, 171, 119, 135, 186,
		209, 200, 200, 222, 215, 159, 129, 154,
		209, 205, 200, 199, 217, 214, 163, 134,
		209, 208, 203, 191, 198, 218, 195, 153,
		209, 205, 201, 202, 191, 188, 205, 187};
	int dst[81];
	int stride = 8;

	idx=0;
	val=0;
	val |= src[idx];
	val |= src[idx+=stride] << 8;
	val |= src[idx+=stride] << 16;
	val |= src[idx+=stride] << 24;
	*(ppixels++) = val;
	val = 0;
	val |= src[idx+=stride];
	val |= src[idx+=stride] << 8;
	val |= src[idx+=stride] << 16;
	val |= src[idx+=stride] << 24;
	*(ppixels++) = val;
	val = 0;
	val |= src[idx+=stride];
	*(ppixels++) = val;
	
	*reg_r = 0;
	*reg_mode = 0;

	ppixels = pixels_base + 9;
	idx=1;
	dst[idx] = *(ppixels++);
	dst[idx+=stride] = *(ppixels++);
	dst[idx+=stride] = *(ppixels++);
	dst[idx+=stride] = *(ppixels++);
	dst[idx+=stride] = *(ppixels++);
	dst[idx+=stride] = *(ppixels++);
	dst[idx+=stride] = *(ppixels++);
	dst[idx+=stride] = *(ppixels++);

	printf("result: %d, %d, %d, %d, %d, %d, %d, %d\n", dst[1], dst[9], dst[17], dst[25], dst[33], dst[41], dst[49], dst[57]);
    return 0;
}
