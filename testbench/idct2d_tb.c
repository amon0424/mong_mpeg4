/* /////////////////////////////////////////////////////////////////// */
/*  Program : idct_tb.c                                                */
/*  Author  : Chun-Jen Tsai                                            */
/*  Date    : 05/22/2008                                               */
/* ------------------------------------------------------------------- */
/*     This program generates random 8x8 image pixel blocks to test    */
/* and see if the hardware IDCT accelerator logic matches the behavior */
/* of the C Model exactly. For formal conformance testing, you should  */
/* apply the test procedure described in the (obsolete) IEEE 1180-1990 */
/* standard, which uses floating point IDCT reference implementations. */
/* ------------------------------------------------------------------- */
/* This program is designed for the class "Embedded Firmware and       */
/* Hardware/Software Co-design" in Spring, 2008.                       */
/*                                                                     */
/* Department of Computer Science                                      */
/* National Chiao Tung University                                      */
/* 1001 Ta-Hsueh Rd., Hsinchu, 30010, Taiwan                           */
/* /////////////////////////////////////////////////////////////////// */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>    /* for generating random number seeds */

#define NO_ECOS 0

/* HW accelerator interface */
long *F_array           = (long *) 0xb0100000;
long *p_array           = (long *) 0xb0100010;
volatile long *action   = (long *) 0xb0100080;

/* DCT kernel matrices */
long dct_HU[] = {
     724,   724,  724,  724,
     946,   392, -392, -946,
     724,  -724, -724,  724,
     392,  -946,  946, -392
};

long dct_HL[] = {
    1004,  -851,   569, -200,
     851,   200, -1004,  569,
     569,  1004,   200, -851,
     200,   569,   851, 1004
};

void
dct_1d(short *dct, short *value, int row)
{
    void H_mul_v(long *v4dst, long *m4x4, long *v4src);
    long v[4], F_eve[4], F_odd[4];

    /* compute even-point values */
    v[0] = (value[0] + value[7]);
    v[1] = (value[1] + value[6]);
    v[2] = (value[2] + value[5]);
    v[3] = (value[3] + value[4]);
    H_mul_v(F_eve, dct_HU, v);

    /* compute odd-point values */
    v[0] = (value[0] - value[7]);
    v[1] = (value[6] - value[1]);
    v[2] = (value[2] - value[5]);
    v[3] = (value[4] - value[3]);
    H_mul_v(F_odd, dct_HL, v);

    /* save result */
    dct[(0<<3)+row] = (short) (F_eve[0]+1024) >> 11;
    dct[(1<<3)+row] = (short) (F_odd[0]+1024) >> 11;
    dct[(2<<3)+row] = (short) (F_eve[1]+1024) >> 11;
    dct[(3<<3)+row] = (short) (F_odd[1]+1024) >> 11;
    dct[(4<<3)+row] = (short) (F_eve[2]+1024) >> 11;
    dct[(5<<3)+row] = (short) (F_odd[2]+1024) >> 11;
    dct[(6<<3)+row] = (short) (F_eve[3]+1024) >> 11;
    dct[(7<<3)+row] = (short) (F_odd[3]+1024) >> 11;
}

void
dct_2d(short *block)
{
    int row;
    short tmem[64];

    /* row transform */
    for (row = 0; row < 8; row++)
    {
        dct_1d(tmem, block+(row<<3), row);
    }

    /* column transform */
    for (row = 0; row < 8; row++)
    {
        dct_1d(block, tmem+(row<<3), row);
    }
}

/* ========================== begin of IDCT C model ==================== */
/* IDCT kernel matrices */
long idct_HU[] = {
     724,   946,  724,  392,
     724,   392, -724, -946,
     724,  -392, -724,  946,
     724,  -946,  724, -392
};

long idct_HL[] = {
    1004,   851,  569,  200,
    -851,   200, 1004,  569,
     569, -1004,  200,  851,
    -200,   569, -851, 1004
};

void
H_mul_v(long *v4dst, long *m4x4, long *v4src)
{
    int row;

    for (row = 0; row < 4; row++)
    {
        v4dst[row] = m4x4[(row<<2)+0] * v4src[0] +
                     m4x4[(row<<2)+1] * v4src[1] +
                     m4x4[(row<<2)+2] * v4src[2] +
                     m4x4[(row<<2)+3] * v4src[3];
    }
}

void
idct_1d(short *idct, short *coeff, int row)
{
    long v[4], g[8];

    /* compute even-point values */
    v[0] = coeff[0];
    v[1] = coeff[2];
    v[2] = coeff[4];
    v[3] = coeff[6];
    H_mul_v(g, idct_HU, v);

    /* compute odd-point values */
    v[0] = coeff[1];
    v[1] = coeff[3];
    v[2] = coeff[5];
    v[3] = coeff[7];
    H_mul_v(g+4, idct_HL, v);

    /* scale-down and save result */
    idct[(0<<3)+row] = (short) ((g[0]+g[4]+1024) >> 11);
    idct[(1<<3)+row] = (short) ((g[1]-g[5]+1024) >> 11);
    idct[(2<<3)+row] = (short) ((g[2]+g[6]+1024) >> 11);
    idct[(3<<3)+row] = (short) ((g[3]-g[7]+1024) >> 11);
    idct[(4<<3)+row] = (short) ((g[3]+g[7]+1024) >> 11);
    idct[(5<<3)+row] = (short) ((g[2]-g[6]+1024) >> 11);
    idct[(6<<3)+row] = (short) ((g[1]+g[5]+1024) >> 11);
    idct[(7<<3)+row] = (short) ((g[0]-g[4]+1024) >> 11);
}

void
idct_2d(short *block)
{
    int row;
    short tmem[64];  /* 2-D IDCT transpose memory */

    /* row transform */
    for (row = 0; row < 8; row++)
    {
        idct_1d(tmem, block+(row<<3), row);
    }

    /* column transform */
    for (row = 0; row < 8; row++)
    {
        idct_1d(block, tmem+(row<<3), row);
    }
}
/* ========================== End of IDCT C model ==================== */

void
hw_idct_2d(short *block)
{
	int idx, result, row;
	short* blockBase;
	long* fBase;
	memcpy((void *) F_array, (void *) block, sizeof(short)<<6);

	*action=1;
	while(*action);

	blockBase = block;
	fBase = F_array;
	for(row=0;row<8;row++)
	{
		result = *(fBase++);
		*(blockBase++) = (short)(result >> 16);
		*(blockBase++) = (short)(result);

		result = *(fBase++);
		*(blockBase++) = (short)(result >> 16);
		*(blockBase++) = (short)(result);

		result = *(fBase++);
		*(blockBase++) = (short)(result >> 16);
		*(blockBase++) = (short)(result);

		result = *(fBase++);
		*(blockBase++) = (short)(result >> 16);
		*(blockBase++) = (short)(result);
	}
}

int
main(int arc, char *arv[])
{
	int i, block_no, idx;
    int max_error, error, overall_max_error;
    short block[64];      /* buffer for IDCT test patterns */
    short last_block_hw[64], block_hw[64];   /* buffer for HW IDCT inputs     */
	
	unsigned int clk = clock();

   
    printf("Start testing IDCT.\n");
    overall_max_error = 0;
	for(i=0; i<2; i++)
	{
		srand(clk);
		//printf("rand: %d\n", rand());

		for (block_no = 0; block_no < 1024; block_no++)
		{
			/* generate test pattern */
			for (idx = 0; idx < 64; idx++)
			{
				block[idx] = (short) ((rand() % 510) - 255);
			}

			/* compute forward dct transform on the test blocks */
			dct_2d(block);
	#if NO_ECOS /* memcpy() has problems under eCos 1.0.8 */
			memcpy((void *) block_hw, (void *) block, sizeof(block_hw));
	#else
			for (idx = 0; idx < 64; idx++)
			{
				block_hw[idx] = block[idx];
			}
	#endif

	#if 0
			/* display one 8x8 block of DCT test coefficients */
			printf("DCT Coefficients = [\n");
			for (idx = 0; idx < 64; idx++)
			{
				printf(((idx+1)%8)? "%5d " : "%5d\n", block[idx]);
			}
			printf("]\n");
	#endif

			/* compute the C-Model idct output */
			idct_2d(block);

			/* compute idct using the hardware logic */
			hw_idct_2d(block_hw);

			/* find peak error per pixel */
			max_error = 0;
			for (idx = 0; idx < 64; idx++)
			{
				error = abs(block_hw[idx] - block[idx]);
				if (error > max_error) max_error = error;
			}
		
			if(max_error > 0)
			{
				printf("Peak HW error @ block #%4d = %d\n", block_no, max_error);
				
				printf("SW Result = [\n");
				for (idx = 0; idx < 64; idx++)
				{
					printf(((idx+1)%8)? "%5d " : "%5d\n", block[idx]);
				}
				printf("]\n");

				printf("HW Result = [\n");
				for (idx = 0; idx < 64; idx++)
				{
					printf(((idx+1)%8)? "%5d " : "%5d\n", block_hw[idx]);
				}
				printf("]\n");

				//printf("Last HW Result = [\n");
				//for (idx = 0; idx < 64; idx++)
				//{
				//	printf(((idx+1)%8)? "%5d " : "%5d\n", last_block_hw[idx]);
				//}
				//printf("]\n");
			}
			if (max_error > overall_max_error) overall_max_error = max_error;

			for (idx = 0; idx < 64; idx++)
			{
				last_block_hw[idx] = block_hw[idx];
			}
		}
	}
    printf("\nOverall max HW IDCT pixel error = %d\n", overall_max_error);

    return 0;
}
