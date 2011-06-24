/* ///////////////////////////////////////////////////////////////////////// */
/*   File:  : bilinear8x8.c                                                  */
/*   Author : Chun-Jen Tsai                                                  */
/*   Date   : Feb/03/2003                                                    */
/* ------------------------------------------------------------------------- */
/*   MPEG-4 half-pel interpolation functions.                                */
/*   Copyright, 2003.                                                        */
/*   Multimedia Embedded Systems Lab.                                        */
/*   Department of Computer Science and Information engineering              */
/*   National Chiao Tung University, Hsinchu 300, Taiwan                     */
/* ///////////////////////////////////////////////////////////////////////// */

#include "metypes.h"
#include "bilinear8x8.h"

#define USE_HW_MC_FINAL_DMA 0
#define USE_HW_MC_FINAL 1
#define USE_HW_MC_LAB3_ORI 0
#define USE_HW_MC 0

#if USE_HW_MC_FINAL_DMA
volatile long *dma_srcaddr  = (long *) 0xb0300000;
volatile long *dma_dstaddr  = (long *) 0xb0300004;
volatile unsigned long *dma_other  = (long *) 0xb0300008;
volatile long *dma_src_stride  = (long *) 0xb030000C;
volatile long *dma_src_width  = (long *) 0xb0300010;
volatile long *dma_dst_stride  = (long *) 0xb0300014;
volatile long *dma_dst_width  = (long *) 0xb0300018;
volatile long *dma_r  = (long *) 0xb030001C;
volatile long *mcomp_data  = (long *) 0xb0000000;
#elif USE_HW_MC_FINAL
volatile int *reg_r  = (int *) 0xb000006c;
volatile int *reg_mode = (int *) 0xb0000070;
volatile long *mcomp_data  = (long *) 0xb0000000;
#elif USE_HW_MC_LAB3_ORI
volatile int *reg_a  = (int *) 0xb0000000;
volatile int *reg_b  = (int *) 0xb0000004;
volatile int *reg_c  = (int *) 0xb0000008;
volatile int *reg_d  = (int *) 0xb000000c;
volatile int *reg_r  = (int *) 0xb0000010;
volatile int *mc_2pt = (int *) 0xb0000014;
volatile int *mc_4pt = (int *) 0xb0000018;
#elif USE_HW_MC
volatile int *pixels_base = (int *) 0xb0000000;
volatile int *reg_r  = (int *) 0xb000006C;
volatile int *reg_mode = (int *) 0xb0000070;
#endif

void
halfpel8x8_h(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint    row, col, idx;
	xint	i;

    idx = 0;
#if USE_HW_MC_FINAL
	volatile int* ppixels = mcomp_data;
	unsigned int val;

	idx=0;
	for (row = 0; row < (stride << 3); idx = (row += stride))
	{
		val=0;
		val |= src[idx] << 24 | (src[idx+1] << 16) | (src[idx+2] << 8) | (src[idx+3]);
		*(ppixels++) = val;

		val=0;
		val |= src[idx+4] << 24 | (src[idx+5] << 16) | (src[idx+6] << 8) | (src[idx+7]);
		*(ppixels++) = val;

		val=src[idx+8] << 24;
		*(ppixels++) = val;
	}

	*reg_r = rounding;
	*reg_mode = 0;

	// read
	ppixels = mcomp_data;
	idx=0;
	for (row = 0; row < (stride << 3); idx = (row += stride))
	{
		*((int*)(dst+idx)) = *(ppixels++);
		*((int*)(dst+idx+4)) = *(ppixels++);
	}

#elif USE_HW_MC_LAB3_ORI
    for (row = 0; row < (stride << 3); idx = (row += stride))
    {
        for (col = 0; col < 8; col++, idx++)
        {
            *reg_a = (xint) src[idx];
            *reg_b = (xint) src[idx+1];
            *reg_r = (xint) rounding;
            dst[idx] = (uint8) (*mc_2pt);
        }
    }
#elif USE_HW_MC
	volatile int* ppixels = pixels_base;
	uint val;

	for (row = 0; row < (stride << 3); idx = (row += stride))
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

		// additional
		val=0;
		val |= src[idx];
		*(ppixels++) = val;
	}
	

	*reg_r = (xint) rounding;
	*reg_mode = 0;

	idx = 0;
	ppixels = pixels_base;
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
		dst[idx] = (val >> 24) & 0xFF;

		// skip additional
		ppixels++;
	}
#else
	for (row = 0; row < (stride << 3); idx = (row += stride))
    {
		for(col=0; col<8; col++, idx++)
		{
            xint sum = (xint) src[idx] + src[idx + 1] + 1 - rounding;
            dst[idx] = (uint8) (sum >> 1);
		}
	}
#endif
}

void
halfpel8x8_v(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint    row, col, idx;

    idx = 0;

#if USE_HW_MC_FINAL
	volatile int* ppixels = mcomp_data;
	unsigned int val;
	
	idx=0;
	for (row = 0; row < (stride << 3) + stride; idx = (row += stride))
	{
		val=0;
		val |= src[idx] << 24 | (src[idx+1] << 16) | (src[idx+2] << 8) | (src[idx+3]);
		*(ppixels++) = val;

		val=0;
		val |= src[idx+4] << 24 | (src[idx+5] << 16) | (src[idx+6] << 8) | (src[idx+7]);
		*(ppixels++) = val;

		ppixels++;
	}

	*reg_r = rounding;
	*reg_mode = 1;

	// read
	ppixels = mcomp_data;
	idx=0;
	for (row = 0; row < (stride << 3); idx = (row += stride))
	{
		*((int*)(dst+idx)) = *(ppixels++);
		*((int*)(dst+idx+4)) = *(ppixels++);
	}
#elif USE_HW_MC
    volatile int* ppixels = pixels_base;
	uint val;
	for (row = 0; row < (stride << 3) + stride; idx = (row += stride))
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
		val |= src[idx] << 24;
		*(ppixels++) = val;

		// skip additional
		ppixels++;
	}

	*reg_r = (xint) rounding;
	*reg_mode = 1;

	idx = 0;
	ppixels = pixels_base;
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
		dst[idx] = (val >> 24) & 0xFF;

		// skip additional
		ppixels++;
	}
#else
	for (row = 0; row < (stride << 3); idx = (row += stride))
	{	
		for (col = 0; col < 8; col++, idx++)
		{
			xint sum = (xint) src[idx] + src[idx + stride] + 1 - rounding;
			dst[idx] = (uint8) (sum >> 1);
		}
	}
#endif
}

void
halfpel8x8_hv(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint    row, col, idx;

    idx = 0;
#if USE_HW_MC_FINAL
	volatile int* ppixels = mcomp_data;
	unsigned int val;
	
	idx=0;
	for (row = 0; row < (stride << 3) + stride; idx = (row += stride))
	{
		val=0;
		val |= src[idx] << 24 | (src[idx+1] << 16) | (src[idx+2] << 8) | (src[idx+3]);
		*(ppixels++) = val;

		val=0;
		val |= src[idx+4] << 24 | (src[idx+5] << 16) | (src[idx+6] << 8) | (src[idx+7]);
		*(ppixels++) = val;

		val=src[idx+8] << 24;
		*(ppixels++) = val;
	}

	*reg_r = rounding;
	*reg_mode = 2;

	// read
	ppixels = mcomp_data;
	idx=0;
	for (row = 0; row < (stride << 3); idx = (row += stride))
	{
		*((int*)(dst+idx)) = *(ppixels++);
		*((int*)(dst+idx+4)) = *(ppixels++);
	}
#elif USE_HW_MC
	volatile int* ppixels = pixels_base;
	uint val;
	for (row = 0; row < (stride << 3) + stride; idx = (row += stride))
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

		// additional
		val=0;
		val |= src[idx];
		*(ppixels++) = val;

	}
	*reg_r = (xint) rounding;
	*reg_mode = 2;

	idx = 0;
	ppixels = pixels_base;
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
		dst[idx] = (val >> 24) & 0xFF;

		// skip additional
		ppixels++;
	}
#else
    for (row = 0; row < (stride << 3); idx = (row += stride))
	{
		for(col=0; col<8; col++, idx++)
		{
			xint sum = (xint) src[idx] + (xint) src[idx + 1] +
				(xint) src[idx + stride] + (xint) src[idx + stride + 1];
			dst[idx] = (uint8) ((sum + 2 - rounding) >> 2);
		}
	}
#endif
    
}
