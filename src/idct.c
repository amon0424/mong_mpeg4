#include <string.h>
#include <stdio.h>
#define USE_HW_IDCT_2D 1
#define USE_HW_IDCT 1

#if USE_HW_IDCT_2D
long *F_array            = (long *) 0xb0100000;
long *p_array            = (long *) 0xb0100000;
volatile long *action   = (long *) 0xb0100080;

void
idct(short *block)
{
		int row;
	long tmp;
	long* lblockBase;
	long* pBase;
	long* fBase;
	

	lblockBase = (long*)block;
	fBase = F_array;

	memcpy(fBase, lblockBase, 16);
	memcpy(fBase+4, lblockBase+4, 16);
	memcpy(fBase+8, lblockBase+8, 16);
	memcpy(fBase+12, lblockBase+12, 16);
	memcpy(fBase+16, lblockBase+16, 16);
	memcpy(fBase+20, lblockBase+20, 16);
	memcpy(fBase+24, lblockBase+24, 16);
	memcpy(fBase+28, lblockBase+28, 16);
	
	*action=1;
	while(*action);

	lblockBase = (long*)block;
	pBase = F_array;

	for(row=0;row<8;row++)
	{	
		//memcpy(lblockBase, pBase, 16); lblockBase+=4; pBase+=4;
		asm volatile( 
			"ld [%3], %2; \
			 st %2, [%4]; \
			 ld [%3+4], %2; \
			 st %2, [%4+4]; \
			 ld [%3+8], %2; \
			 st %2, [%4+8]; \
			 ld [%3+12], %2; \
			 st %2, [%4+12]; \
			 add %3, 16, %0; \
			 add %4, 16, %1;" 
			: "=r" (pBase), "=r" (lblockBase), "=&r" (tmp)
			: "0" (pBase), "1" (lblockBase)
			);
	}
}


#elif USE_HW_IDCT  /* ========== HW IDCT ============ */

/* HW accelerator interface */
long *F_array            = (long *) 0xb0100000;
long *p_array            = (long *) 0xb0100010;
volatile long *action   = (long *) 0xb0100020;

/* 2-D IDCT transpose memory */
static short tmem[64];

void
idct(short *block)
{
    int row, col;

    /* row transform */
    for (row = 0; row < 8; row++)
    {
#if 0 /* memcpy() has problems under eCos 1.0.8 */
        memcpy((void *) F_array, (void *) (block+(row<<3)), sizeof(short)<<3);
#else
        for (col = 0; col < 8; col+=2)
        {
            F_array[col>>1] = *((long *) (block+(row<<3)+col));
        }
#endif
        *action = 1;
        while (*action) /* do nothing */;
        for (col = 0; col < 8; col++)
        {
            tmem[(col<<3)+row] = ((short *) p_array)[col];
        }
    }

    /* column transform */
    for (row = 0; row < 8; row++)
    {
#if 0 /* memcpy() has problems under eCos 1.0.8 */
        memcpy((void *) F_array, (void *) (tmem+(row<<3)), sizeof(short)<<3);
#else
        for (col = 0; col < 8; col += 2)
        {
            F_array[col>>1] = *((long *) (tmem+(row<<3)+col));
        }
#endif
        *action = 1;
        while (*action) /* do nothing */;
        for (col = 0; col < 8; col++)
        {
            block[(col<<3)+row] = ((short *) p_array)[col];
        }
    }
}

#else /* ========== SW IDCT ============ */

static int c0 = 1448; /* 2048 * 0.7071068 */
static int c1 = 1004; /* 2048 * 0.4903926 */
static int c2 =  946; /* 2048 * 0.4619398 */
static int c3 =  851; /* 2048 * 0.4157348 */
static int c4 =  724; /* 2048 * 0.3535534 */
static int c5 =  569; /* 2048 * 0.2777851 */
static int c6 =  392; /* 2048 * 0.1913417 */
static int c7 =  200; /* 2048 * 0.0975452 */

void
idct_1d(short *output, short *input)
{
    short tmp[8];
    int j1, i, j;
    int yy0, yy1, yy2, yy3, yy5, yy6;
    int e, f, g, h;

    for (i = 0; i < 8; i++)
    {
        memcpy(tmp, input + (i<<3), 8*sizeof(short));
        e      = tmp[1] * c7 - tmp[7] * c1;
        h      = tmp[7] * c7 + tmp[1] * c1;
        f      = tmp[5] * c3 - tmp[3] * c5;
        g      = tmp[3] * c3 + tmp[5] * c5;
        yy0    = (tmp[0] + tmp[4]) * c4;
        yy1    = (tmp[0] - tmp[4]) * c4;
        yy2    = tmp[2] * c6 - tmp[6] * c2;
        yy3    = tmp[6] * c6 + tmp[2] * c2;
        tmp[4] = (e + f + 1024)>>11;
        yy5    = (e - f + 1024)>>11;
        yy6    = (h - g + 1024)>>11;
        tmp[7] = (h + g + 1024)>>11;

        tmp[5] = ((yy6 - yy5) * c0)>>11;
        tmp[6] = ((yy6 + yy5) * c0)>>11;
        tmp[0] = (yy0 + yy3 + 1024)>>11;
        tmp[1] = (yy1 + yy2 + 1024)>>11;
        tmp[2] = (yy1 - yy2 + 1024)>>11;
        tmp[3] = (yy0 - yy3 + 1024)>>11;

        for (j = 0; j < 4; j++)
        {
            j1 = 7 - j;
            output[(j<<3)+i]  = tmp[j] + tmp[j1];
            output[(j1<<3)+i] = tmp[j] - tmp[j1];
        }
    }
}

void
idct(short *block)
{
    short idx, v;
    short tbuf[64];

    /* Horizontal */
    idct_1d(tbuf, block);

    /* Vertical */
    idct_1d(block, tbuf);

    for (idx = 0; idx < 64; idx++)
    {
        v = block[idx];
        block[idx] = (v < -256)? -256 : ((v > 255)? 255 : v);
	}
}
#endif
