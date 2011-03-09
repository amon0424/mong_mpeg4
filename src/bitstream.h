 /******************************************************************************
  *                                                                            *
  *  This file is part of XviD, a free MPEG-4 video encoder/decoder            *
  *                                                                            *
  *  XviD is an implementation of a part of one or more MPEG-4 Video tools     *
  *  as specified in ISO/IEC 14496-2 standard.  Those intending to use this    *
  *  software module in hardware or software products are advised that its     *
  *  use may infringe existing patents or copyrights, and any such use         *
  *  would be at such party's own risk.  The original developer of this        *
  *  software module and his/her company, and subsequent editors and their     *
  *  companies, will have no liability for use of this software or             *
  *  modifications or derivatives thereof.                                     *
  *                                                                            *
  *  XviD is free software; you can redistribute it and/or modify it           *
  *  under the terms of the GNU General Public License as published by         *
  *  the Free Software Foundation; either version 2 of the License, or         *
  *  (at your option) any later version.                                       *
  *                                                                            *
  *  XviD is distributed in the hope that it will be useful, but               *
  *  WITHOUT ANY WARRANTY; without even the implied warranty of                *
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
  *  GNU General Public License for more details.                              *
  *                                                                            *
  *  You should have received a copy of the GNU General Public License         *
  *  along with this program; if not, write to the Free Software               *
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA  *
  *                                                                            *
  ******************************************************************************/

 /******************************************************************************
  *                                                                            *
  *  bitstream.h                                                               *
  *                                                                            *
  *  Copyright (C) 2001 - Peter Ross <pross@cs.rmit.edu.au>                    *
  *                                                                            *
  *  For more information visit the XviD homepage: http://www.xvid.org         *
  *                                                                            *
  ******************************************************************************/

 /******************************************************************************
  *																			   *
  *  Revision history:                                                         *
  *                                                                            *
  *  26.03.2002 interlacing support - modified putvol/vopheaders paramters
  *  04.03.2002 putbits speedup (Isibaar)                                      *
  *  03.03.2002 merged BITREADER and BITWRITER (Isibaar)                       *
  *	 16.12.2001	inital version                                           	   *
  *																			   *
  ******************************************************************************/

#ifndef _BITSTREAM_H_
#define _BITSTREAM_H_

#include <string.h>
#include "m4vdec_api.h"

#define VIDOBJ_START_CODE		0x00000100      /* ..0x0000011f  */
#define VIDOBJLAY_START_CODE	0x00000120      /* ..0x0000012f */
#define VISOBJSEQ_START_CODE	0x000001b0
#define VISOBJSEQ_STOP_CODE		0x000001b1      /* ??? */
#define USERDATA_START_CODE		0x000001b2
#define GRPOFVOP_START_CODE		0x000001b3
#define VISOBJ_START_CODE		0x000001b5

#define VISOBJ_TYPE_VIDEO				1

#define VIDOBJLAY_TYPE_SIMPLE			1
#define VIDOBJLAY_TYPE_CORE				3
#define VIDOBJLAY_TYPE_MAIN				4
#define VIDOBJLAY_AR_EXTPAR				15

#define VIDOBJLAY_SHAPE_RECTANGULAR		0
#define VIDOBJLAY_SHAPE_BINARY			1
#define VIDOBJLAY_SHAPE_BINARY_ONLY		2
#define VIDOBJLAY_SHAPE_GRAYSCALE		3

#define VISUAL_OBJECT_SEQ_START_CODE 0x1b0
#define VISUAL_OBJECT_START_CODE     0x1b5
#define VO_START_CODE  0x8
#define VOL_START_CODE 0x12
#define VOP_START_CODE 0x1b6

/* DC and motion markers used in data-partitioning mode */
#define DC_MARKER                     0x06B001
#define DC_MARKER_LENGTH              19

#define MOTION_MARKER                 0x01F001
#define MOTION_MARKER_LENGTH          17

#define READ_MARKER()	BitstreamSkip(bs, 1)

// vop coding types
// intra, prediction, backward, sprite, not_coded
#define I_VOP	0
#define P_VOP	1
#define B_VOP	2
#define S_VOP	3
#define N_VOP	4

void BitstreamInit(Bitstream *const bs, void *const bitstream, uint32 length);
void BitstreamReset(Bitstream * const bs);
void BitstreamSkip(Bitstream * const bs, const uint32 bits);
uint32 BitstreamLength(Bitstream * const bs);
void BitstreamForward(Bitstream * const bs, const uint32 bits);
int BitstreamReadHeaders(Bitstream * bs, DECODER * dec, uint32 * rounding,
                     uint32 * quant, uint32 * fcode, uint32 * intra_dc_thresh);

static int __inline
log2bin(int value)
{
    int n = 0;
    while (value)
    {
        value >>= 1;
        n++;
    }
    return n;
}

/* reads n bits from bitstream without changing the stream pos */
static uint32 __inline
BitstreamShowBits(Bitstream * const bs, const uint32 bits)
{
    int     nbit = (bits + bs->pos) - 32;
    if (nbit > 0)
    {
        return ((bs->bufa & (0xffffffff >> bs->pos)) << nbit) |
            (bs->bufb >> (32 - nbit));
    }
    else
    {
        return (bs->bufa & (0xffffffff>>bs->pos)) >> (32-bs->pos-bits);
    }
}

static uint32 __inline
BitstreamShowBitsByteAlign(Bitstream *const bs, const uint32 bits)
{
    int     extra_bits = 8 - (bs->pos % 8);
    int     nbit = (bits + extra_bits + bs->pos) - 32;
    uint32  temp;

    if (nbit > 0)
    {
        temp =
            ((bs->bufa & (0xffffffff >> bs->pos)) << nbit) |
             (bs->bufb >> (32 - nbit));
    }
    else
    {
        temp = (bs->bufa & (0xffffffff >> bs->pos)) >> (-nbit);
    }
    return temp & (0xffffffff >> (32 - bits));
}

/* move forward to the next byte boundary */
static __inline void
BitstreamByteAlignNoForceStuffing(Bitstream * const bs)
{
    uint32  remainder = bs->pos % 8;
    if (remainder)
        BitstreamSkip(bs, 8 - remainder);
}

static __inline void
BitstreamByteAlign(Bitstream * const bs)
{
    /* Note: In MPEG-4, Byte-align operations always insert */
    /*    at least one bit.  That is, if remainder == 0, we */
    /*    must insert 8 bits.                CJ Feb/05/2003 */
    uint32  remainder = bs->pos % 8;
    BitstreamSkip(bs, 8 - remainder);
}

/* bitstream length (unit bits) */
static uint32 __inline
BitstreamPos(const Bitstream * const bs)
{
    return 8 * ((uint32) bs->tail - (uint32) bs->start) + bs->pos;
}

/* read n bits from bitstream */
static uint32 __inline
BitstreamGetBits(Bitstream * const bs, const uint32 n)
{
    uint32  ret = BitstreamShowBits(bs, n);
    BitstreamSkip(bs, n);
    return ret;
}

/* read single bit from bitstream */
static uint32 __inline
BitstreamGetBit(Bitstream * const bs)
{
    return BitstreamGetBits(bs, 1);
}

/* write single bit to bitstream */
static void __inline
BitstreamPutBit(Bitstream * const bs, const uint32 bit)
{
    if (bit)
        bs->buf |= (0x80000000 >> bs->pos);

    BitstreamForward(bs, 1);
}

/* ================================================================== */
/*    Function : decode_video_packet_header()                         */
/*    Author   : CJ Tsai,                                             */
/*    Date     : Feb/04/2003                                          */
/* ------------------------------------------------------------------ */
/*    The function check if we have valid stuffing pattern.           */
/* ================================================================== */
static int __inline
valid_stuffing(Bitstream * bs)
{
    static const int mask[8] =
        { 0x00, 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f };
    xint    remainder = 8 - (bs->pos % 8);
    xint    temp = BitstreamShowBits(bs, remainder);
    return (temp == mask[remainder - 1]);
}

#endif /* _BITSTREAM_H_ */
