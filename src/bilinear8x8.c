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
    xint    row, col, idx, sum;
	xint lastIdxPlusOne,idxPlusOne;

    idx = 0;
    for (row = 0; row < (stride << 3); idx = (row += stride))
    {
		lastIdxPlusOne = (xint)src[idx];
        for (col = 0; col < 8; col++, idx++)
        {
			idxPlusOne = (xint) src[idx + 1];
            sum = lastIdxPlusOne + idxPlusOne + 1 - rounding;
            dst[idx] = (uint8) (sum >> 1);
			lastIdxPlusOne = idxPlusOne;
        }
    }
}



void
halfpel8x8_v(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint    row, col, idx, sum, idxPlusStride;
	xint buffer[8];

    idx = 0;
	for (col = 0; col < 8; col++)
		buffer[col] = (xint)src[col];
	
    for (row = 0; row < (stride << 3); idx = (row += stride))
    {
        for (col = 0; col < 8; col++, idx++)
        {
			idxPlusStride = (xint) src[idx + stride];

            sum = buffer[col] + idxPlusStride + 1 - rounding;
            dst[idx] = (uint8) (sum >> 1);

			buffer[col] = idxPlusStride;
        }
    }
}

void
halfpel8x8_hv(uint8 * dst, uint8 * src, xint stride, xint rounding)
{
    xint    row, col, idx, sum;
	xint lastIdxPlusOne, lastIdxPlusStridePlusOne;
	xint idxPlusOne, idxPlusStridePlusOne;

    idx = 0;
    for (row = 0; row < (stride << 3); idx = (row += stride))
    {
		lastIdxPlusOne = (xint)src[idx];
		lastIdxPlusStridePlusOne = (xint)src[idx + stride];

        for (col = 0; col < 8; col++, idx++)
        {
			idxPlusOne = (xint) src[idx + 1];
			idxPlusStridePlusOne = (xint) src[idx + stride + 1];

            sum = lastIdxPlusOne + idxPlusOne + lastIdxPlusStridePlusOne + idxPlusStridePlusOne;
            dst[idx] = (uint8) ((sum + 2 - rounding) >> 2);

			lastIdxPlusOne = idxPlusOne;
			lastIdxPlusStridePlusOne = idxPlusStridePlusOne;
        }
    }
}
