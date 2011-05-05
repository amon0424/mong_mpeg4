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
volatile int *reg_r  = (int *) 0xb00001B4;
volatile int *reg_mode = (int *) 0xb00001B8;
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
	int i,j,m, idx, row;
	volatile unsigned int* ppixels;
	unsigned int val;

	unsigned int src[81] = 
		{209, 169, 123, 126, 167, 188, 197, 211, 211,
		209, 169, 123, 126, 167, 188, 197, 211,211,
		209, 182, 169, 135, 128, 168, 199, 205,205,
		209, 195, 208, 171, 121, 132, 175, 200,20,
		209, 198, 212, 214, 171, 119, 135, 186,186,
		209, 200, 200, 222, 215, 159, 129, 154,154,
		209, 205, 200, 199, 217, 214, 163, 134,134,
		209, 208, 203, 191, 198, 218, 195, 153,153,
		209, 205, 201, 202, 191, 188, 205, 187,187};
	int dst[81];
	int stride = 9;

	for(m=0; m<3;m++)
	{
		ppixels = pixels_base;
		idx=0;
		for (row = 0; row < (stride << 3)+stride; idx = (row += stride))
		{
			val=0;
			val |= src[idx++];
			val |= src[idx++] << 8;
			val |= src[idx++] << 16;
			val |= src[idx++] << 24;
			*(ppixels++) = val;

			val=0;
			val |= src[idx++];
			val |= src[idx++] << 8;
			val |= src[idx++] << 16;
			val |= src[idx++] << 24;
			*(ppixels++) = val;

			val=0;
			val |= src[idx++];
			*(ppixels++) = val;
		}

		*reg_r = 0;
		*reg_mode = m;

		ppixels = pixels_base;
		idx=0;
		for (row = 0; row < (stride << 3); idx = (row += stride))
		{
			val = *(ppixels++);
			dst[idx++] = val & 0xFF;
			dst[idx++] = (val >> 8) & 0xFF;
			dst[idx++] = (val >> 16) & 0xFF;
			dst[idx++] = (val >> 24) & 0xFF;

			val = *(ppixels++);
			dst[idx++] = val & 0xFF;
			dst[idx++] = (val >> 8) & 0xFF;
			dst[idx++] = (val >> 16) & 0xFF;
			dst[idx++] = (val >> 24) & 0xFF;

			ppixels++;

		}

		idx=0;
		printf("result %d:\n", m);
		for (row = 0; row < (stride << 3); idx = (row += stride))
		{
			for(i=0; i<8; i++, idx++)
				printf("%d,", dst[idx]);
			printf("\n");
		}
	}
    return 0;
}
