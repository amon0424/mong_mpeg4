/**************************************************************************
 *
 *	XVID MPEG-4 VIDEO CODEC
 *	8bit<->16bit transfer
 *
 *	This program is an implementation of a part of one or more MPEG-4
 *	Video tools as specified in ISO/IEC 14496-2 standard.  Those intending
 *	to use this software module in hardware or software products are
 *	advised that its use may infringe existing patents or copyrights, and
 *	any such use would be at such party's own risk.  The original
 *	developer of this software module and his/her company, and subsequent
 *	editors and their companies, will have no liability for use of this
 *	software or modifications or derivatives thereof.
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; either version 2 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *************************************************************************/

/**************************************************************************
 *
 *	History:
 *
 *	07.01.2002	merge functions from compensate; rename functions
 *	22.12.2001	transfer_8to8add16 limit fix
 *	07.11.2001	initial version; (c)2001 peter ross <pross@cs.rmit.edu.au>
 *
 *************************************************************************/

#include "global.h"
#include "mem_transfer.h"

void
transfer_8to16copy(int16 * const dst, const uint8 * const src,
                   xint stride)
{
    uint32  i, j;

    for (j = 0; j < 8; j++)
    {
        for (i = 0; i < 8; i++)
        {
            dst[j * 8 + i] = (int16) src[j * stride + i];
        }
    }
}

void
transfer_16to8copy(uint8 * const dst, const int16 * const src,
                   xint stride)
{
    uint32  i, j;

    for (j = 0; j < 8; j++)
    {
        for (i = 0; i < 8; i++)
        {
            int16   pixel = src[j * 8 + i];
            if (pixel < 0)
            {
                pixel = 0;
            }
            else if (pixel > 255)
            {
                pixel = 255;
            }
            dst[j * stride + i] = (uint8) pixel;
        }
    }
}

/*
  perform motion compensation (and 8bit->16bit dct transfer)
*/
void
transfer_8to16sub(int16 * const dct,
                  uint8 * const cur, const uint8 * ref, xint stride)
{
    uint32  i, j;

    for (j = 0; j < 8; j++)
    {
        for (i = 0; i < 8; i++)
        {
            uint8   c = cur[j * stride + i];
            uint8   r = ref[j * stride + i];
            cur[j * stride + i] = r;
            dct[j * 8 + i] = (int16) c - (int16) r;
        }
    }
}

void
transfer_16to8add(uint8 * const dst, const int16 * const src,
                  xint stride)
{
    uint32 j;

    for (j = 0; j < 8; j++)
    {
		int16 pixel;
		pixel = (int16) dst[j * stride] + src[j * 8];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 0] = (uint8) pixel;

		pixel = (int16) dst[j * stride + 1] + src[j * 8 + 1];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 1] = (uint8) pixel;

		pixel = (int16) dst[j * stride + 2] + src[j * 8 + 2];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 2] = (uint8) pixel;

		pixel = (int16) dst[j * stride + 3] + src[j * 8 + 3];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 3] = (uint8) pixel;

		pixel = (int16) dst[j * stride + 4] + src[j * 8 + 4];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 4] = (uint8) pixel;

		pixel = (int16) dst[j * stride + 5] + src[j * 8 + 5];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 5] = (uint8) pixel;

		pixel = (int16) dst[j * stride + 6] + src[j * 8 + 6];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 6] = (uint8) pixel;

		pixel = (int16) dst[j * stride + 7] + src[j * 8 + 6];
		pixel = (pixel < 0 ? 0 : (pixel > 255 ? 255 : pixel));
        dst[j * stride + 7] = (uint8) pixel;
    }
}

void
transfer8x8_copy(uint8 * const dst, const uint8 * const src,
                 xint stride)
{
    uint32  i, j;

    for (j = 0; j < 8; j++)
    {
		memcpy(dst + j * stride, src + j * stride, 8);
    }
}
