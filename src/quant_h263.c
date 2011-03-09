/**************************************************************************
 *
 *	XVID MPEG-4 VIDEO CODEC
 *	quantization/dequantization
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
 *  26.12.2001	dequant_inter bug fix
 *	22.12.2001	clamp dequant output to [-2048,2047]
 *  19.11.2001  quant_inter now returns sum of abs. coefficient values
 *	02.11.2001	added const to function args <pross@cs.rmit.edu.au>
 *	28.10.2001	total rewrite <pross@cs.rmit.edu.au>
 *
 *************************************************************************/

#include "quant_h263.h"

/*	dequantize intra-block & clamp to [-2048,2047]
*/
void
dequant_intra(int16 * data, const int16 * coeff, const uint32 quant,
              const uint32 dcscalar)
{
    const int32 quant_m_2 = quant << 1;
    const int32 quant_add = (quant & 1 ? quant : quant - 1);
    uint32  i;

    data[0] = coeff[0] * (int16) dcscalar;
    //saturation
    if (data[0] < -2048)
    {
        data[0] = -2048;
    }
    else if (data[0] > 2047)
    {
        data[0] = 2047;
    }

    for (i = 1; i < 64; i++)
    {
        int32   acLevel = coeff[i];
        if (acLevel == 0)
        {
            data[i] = 0;
        }
        else if (acLevel < 0)
        {
            acLevel = quant_m_2 * -acLevel + quant_add;
            //saturation
            data[i] = (acLevel <= 2048 ? -acLevel : -2048);
        }
        else                    //  if (acLevel > 0) {
        {
            acLevel = quant_m_2 * acLevel + quant_add;
            data[i] = (acLevel <= 2047 ? acLevel : 2047);
        }
    }
}

/* dequantize inter-block & clamp to [-2048,2047]
*/

void
dequant_inter(int16 * data, const int16 * coeff, const uint32 quant)
{
    const uint16 quant_m_2 = (uint16) (quant << 1);
    const uint16 quant_add = (uint16) (quant & 1 ? quant : quant - 1);
    uint32  i;

    for (i = 0; i < 64; i++)
    {
        int16   acLevel = coeff[i];

        if (acLevel == 0)
        {
            data[i] = 0;
        }
        else if (acLevel < 0)
        {
            acLevel = acLevel * quant_m_2 - quant_add;
            data[i] = (acLevel >= -2048 ? acLevel : -2048);
        }
        else                    // if (acLevel > 0)
        {
            acLevel = acLevel * quant_m_2 + quant_add;
            data[i] = (acLevel <= 2047 ? acLevel : 2047);
        }
    }
}
