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

void
halfpel8x8_h(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint    row, idx, sum;
    idx = 0;
    for (row = 0; row < (stride << 3); idx = (row += stride))
    {
		xint last_idx_1 = (xint)src[idx];

		xint idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;

		idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;

		idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;

		idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;

		idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;

		idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;

		idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;

		idx_1 = (xint)src[idx + 1];
		sum = last_idx_1 + idx_1 + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
		last_idx_1 = idx_1;
    }
}



void
halfpel8x8_v(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint    row, idx, sum;

    idx = 0;

	for (row = 0; row < (stride << 3); idx = (row += stride))
	{
		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);

		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);

		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);

		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);

		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);

		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);

		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);

		sum = src[idx] + src[idx + stride] + 1 - rounding;
		dst[idx++] = (uint8) (sum >> 1);
	}
}


void
halfpel8x8_hv(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint row, idx, sum;
    idx = 0;
    for (row = 0; row < (stride << 3); idx = (row += stride))
    {
		xint last_idx_1 = (xint)src[idx];
		xint last_idx_stride_1 = (xint)src[idx + stride];

		xint idx_1 = (xint)src[idx + 1];
		xint idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx++] = (uint8) ((sum + 2 - rounding) >> 2);
		last_idx_1 = idx_1;
		last_idx_stride_1 = idx_stride_1;

		idx_1 = (xint)src[idx + 1];
		idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx++] = (uint8) ((sum + 2 - rounding) >> 2);
		last_idx_1 = idx_1;
		last_idx_stride_1 = idx_stride_1;

		idx_1 = (xint)src[idx + 1];
		idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx++] = (uint8) ((sum + 2 - rounding) >> 2);
		last_idx_1 = idx_1;
		last_idx_stride_1 = idx_stride_1;

		idx_1 = (xint)src[idx + 1];
		idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx++] = (uint8) ((sum + 2 - rounding) >> 2);
		last_idx_1 = idx_1;
		last_idx_stride_1 = idx_stride_1;

		idx_1 = (xint)src[idx + 1];
		idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx++] = (uint8) ((sum + 2 - rounding) >> 2);
		last_idx_1 = idx_1;
		last_idx_stride_1 = idx_stride_1;

		idx_1 = (xint)src[idx + 1];
		idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx++] = (uint8) ((sum + 2 - rounding) >> 2);
		last_idx_1 = idx_1;
		last_idx_stride_1 = idx_stride_1;

		idx_1 = (xint)src[idx + 1];
		idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx++] = (uint8) ((sum + 2 - rounding) >> 2);
		last_idx_1 = idx_1;
		last_idx_stride_1 = idx_stride_1;

		idx_1 = (xint)src[idx + 1];
		idx_stride_1 = (xint)src[idx + stride + 1];
		sum = last_idx_1 + idx_1 + last_idx_stride_1 + idx_stride_1;
		dst[idx] = (uint8) ((sum + 2 - rounding) >> 2);
    }
}
