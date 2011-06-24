#include <stdio.h>
#include <string.h>
// 80 pixels 0xb0000000 ~ 0xb0000140

#define USE_HW_MC1 0
#define USE_HW_MC 1

#if USE_HW_MC
volatile int *pixels_base = (int *) 0xb0000000;
//volatile int *reg_a  = (int *) 0xb0000000;
//volatile int *reg_b  = (int *) 0xb0000004;
//volatile int *reg_c  = (int *) 0xb0000008;
//volatile int *reg_d  = (int *) 0xb000000c;
volatile int *reg_r  = (int *) 0xb000006c;
volatile int *reg_mode = (int *) 0xb0000070;
#elif USE_HW_MC1
volatile int *reg_a  = (int *) 0xb0000000;
volatile int *reg_b  = (int *) 0xb0000004;
volatile int *reg_c  = (int *) 0xb0000008;
volatile int *reg_d  = (int *) 0xb000000c;
volatile int *reg_r  = (int *) 0xb0000010;
volatile int *mc_2pt = (int *) 0xb000014C;
volatile int *mc_4pt = (int *) 0xb0000150;
#endif

unsigned char src[32*9] =   {0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,9,10,11,12,13,14,15,16,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,33,34,35,36,37,38,39,40,41,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,41,42,43,44,45,46,47,48,49,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,49,50,51,52,53,54,55,56,57,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,57,58,59,60,61,62,63,64,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
								0,65,66,67,68,69,70,71,72,73,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
int dst[32*9] = {0};
int r[3] = {1,1,2};
int stride = 32;

int
main(int argc, char **argv)
{
	int i,j,m, idx, row;
	volatile unsigned int* ppixels;
	unsigned int val;

	for(m=0; m<3;m++)
	{
		// write
		ppixels = pixels_base;
		idx=0;
		for (row = 0; row < (stride << 3) + stride; idx = (row += stride))
		{
			val=0;
			val |= src[idx] << 24 | (src[idx+1] << 16) | (src[idx+2] << 8) | (src[idx+3]);
			*(ppixels++) = val;

			val=0;
			val |= src[idx+4] << 24 | (src[idx+5] << 16) | (src[idx+6] << 8) | (src[idx+7]);
			*(ppixels++) = val;

			val=src[idx+8];
			*(ppixels++) = val;
		}

		*reg_r = r[m];
		*reg_mode = m;

		// read
		ppixels = pixels_base;
		idx=0;
		for (row = 0; row < (stride << 3); idx = (row += stride))
		{
			//val = *(ppixels++);
			//dst[idx] = (val >> 24) & 0xFF;
			//dst[idx+1] = (val >> 8) & 0xFF;
			//dst[idx+2] = (val >> 16) & 0xFF;
			//dst[idx+3] = (val >> 24) & 0xFF;
			*(dst+idx) = *(ppixels++);

			//val = *(ppixels++);
			//dst[idx+4] = val & 0xFF;
			//dst[idx+5] = (val >> 8) & 0xFF;
			//dst[idx+6] = (val >> 16) & 0xFF;
			//dst[idx+7] = (val >> 24) & 0xFF;
			*(dst+idx+4) = *(ppixels++);

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
