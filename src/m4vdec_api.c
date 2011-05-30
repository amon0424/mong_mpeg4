/**************************************************************************
 *
 *	XVID MPEG-4 VIDEO CODEC
 *	decoder main
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
 *	This program is xvid_free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the xvid_free Software Foundation; either version 2 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program; if not, write to the xvid_free Software
 *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *************************************************************************/

/**************************************************************************
 *
 *	History:
 *
 *  29.03.2002  interlacing fix - compensated block wasn't being used when
 *              reconstructing blocks, thus artifacts
 *              interlacing speedup - used transfers to re-interlace
 *              interlaced decoding should be as fast as progressive now
 *  26.03.2002  interlacing support - moved transfers outside decode loop
 *	26.12.2001	decoder_mbinter: dequant/idct moved within if(coded) block
 *	22.12.2001	block based interpolation
 *	01.12.2001	inital version; (c)2001 peter ross <pross@cs.rmit.edu.au>
 *
 *************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>             // memset

#include "metypes.h"

#include "m4vdec_api.h"
#include "bitstream.h"
#include "mbcoding.h"

#include "quant_h263.h"
#include "idct.h"
#include "mem_transfer.h"
#include "bilinear8x8.h"

#include "mbprediction.h"
#include "timer.h"

#include "image.h"
#include "mem_align.h"

xint
m4v_decode_header(DECODER * dec, uint8 * video_header, xint header_size)
{
    Bitstream bs;
    uint32  rounding;
    uint32  quant;
    uint32  fcode;
    uint32  intra_dc_threshold;

    BitstreamInit(&bs, video_header, header_size);
    BitstreamReadHeaders(&bs, dec, &rounding, &quant, &fcode,
                         &intra_dc_threshold);

    return XVID_ERR_OK;
}

xint
m4v_init_decoder(DEC_CTRL * param, uint8 * video_header,
                 xint header_size)
{
    DECODER *dec;

    dec = xvid_malloc(sizeof(DECODER), CACHE_LINE);
    if (dec == NULL)
    {
        return XVID_ERR_MEMORY;
    }
    param->handle = dec;

    /* decode video header for frame width & height */
    m4v_decode_header(dec, video_header, header_size);
    param->width = dec->width;
    param->height = dec->height;

    dec->mb_width = (dec->width + 15) / 16;
    dec->mb_height = (dec->height + 15) / 16;
    dec->num_mb = dec->mb_height * dec->mb_width;
    dec->nbits_mba = log2bin(dec->num_mb - 1);

    dec->edged_width = 16 * dec->mb_width + 2 * EDGE_SIZE;
    dec->edged_height = 16 * dec->mb_height + 2 * EDGE_SIZE;

    dec->decoder_clock = 0;

    dec->slice =
        xvid_malloc(sizeof(xint) * (dec->mb_width + 1) *
                    (dec->mb_height + 1), CACHE_LINE);
    if (dec->slice == NULL)
        return XVID_ERR_MEMORY;

    if (image_create(&dec->cur, dec->edged_width, dec->edged_height))
    {
        xvid_free(dec);
        return XVID_ERR_MEMORY;
    }

    if (image_create(&dec->refn, dec->edged_width, dec->edged_height))
    {
        image_destroy(&dec->cur, dec->edged_width, dec->edged_height);
        xvid_free(dec);
        return XVID_ERR_MEMORY;
    }

    dec->mbs =
        xvid_malloc(sizeof(MACROBLOCK) * dec->mb_width * dec->mb_height,
                    CACHE_LINE);
    if (dec->mbs == NULL)
    {
        image_destroy(&dec->refn, dec->edged_width, dec->edged_height);
        image_destroy(&dec->cur, dec->edged_width, dec->edged_height);
        xvid_free(dec);
        return XVID_ERR_MEMORY;
    }

    init_timer();

    init_vlc_tables();
    return XVID_ERR_OK;
}

xint
m4v_free_decoder(DEC_CTRL * xparam)
{
    DECODER *dec = (DECODER *) xparam->handle;
    xvid_free(dec->mbs);
    xvid_free(dec->slice);
    image_destroy(&dec->refn, dec->edged_width, dec->edged_height);
    image_destroy(&dec->cur, dec->edged_width, dec->edged_height);
    xvid_free(dec);

    write_timer();
    cleanup_timer();

    return XVID_ERR_OK;
}

static const int32 dquant_table[4] = {
    -1, -2, 1, 2
};

// decode an intra macroblock
int16   block[6 * 64];
int16   data[6 * 64];

void
decoder_mbintra(DECODER * dec,
                MACROBLOCK * pMB,
                const uint32 x_pos,
                const uint32 y_pos,
                const uint32 acpred_flag,
                const uint32 cbp,
                Bitstream * bs,
                const uint32 quant, const uint32 intra_dc_threshold)
{
    uint32  stride = dec->edged_width;
    uint32  stride2 = stride / 2;
    uint32  next_block = stride * 8;
    uint32  i,j;
    uint32  iQuant = pMB->quant;
    uint8  *pY_Cur, *pU_Cur, *pV_Cur;

    pY_Cur = dec->cur.y + (y_pos << 4) * stride + (x_pos << 4);
    pU_Cur = dec->cur.u + (y_pos << 3) * stride2 + (x_pos << 3);
    pV_Cur = dec->cur.v + (y_pos << 3) * stride2 + (x_pos << 3);

    memset(block, 0, 6 * 64 * sizeof(int16));
	int16* tmpBlock = NULL;
    for (i = 0; i < 6; i++)
    {
        uint32  iDcScaler = get_dc_scaler(iQuant, (i < 4) ? 1 : 0);
        int16   predictors[8];
        int     start_coeff;

        start_timer();
        predict_acdc(dec->mbs, x_pos, y_pos, dec->mb_width, i,
                     &block[i * 64], iQuant, iDcScaler, predictors,
                     dec->slice);
        if (!acpred_flag)
        {
            pMB->acpred_directions[i] = 0;
        }
        stop_prediction_timer();

        if (quant < intra_dc_threshold)
        {
            int     dc_size;
            int     dc_dif;

            dc_size =
                i < 4 ? get_dc_size_lum(bs) : get_dc_size_chrom(bs);
            dc_dif = dc_size ? get_dc_dif(bs, dc_size) : 0;

            if (dc_size > 8)
            {
                BitstreamSkip(bs, 1);   // marker
            }

            block[i * 64] = dc_dif;
            start_coeff = 1;
        }
        else
        {
            start_coeff = 0;
        }

        start_timer();
        if (cbp & (1 << (5 - i)))       // coded
        {
            get_intra_block(bs, &block[i * 64],
                            pMB->acpred_directions[i], start_coeff);
        }
        stop_coding_timer();

        start_timer();
        add_acdc(pMB, i, &block[i * 64], iDcScaler, predictors);
        stop_prediction_timer();

        start_timer();
        dequant_intra(&data[i * 64], &block[i * 64], iQuant, iDcScaler);
        stop_iquant_timer();

        /*start_timer();
		idct(&data[i * 64]);
        stop_idct_timer();*/
		
		if(tmpBlock!=NULL)
		{
			start_timer();
			idct_dual(tmpBlock, &data[i * 64]);
			stop_idct_timer();
			tmpBlock = NULL;
		}
		else
		{
			tmpBlock = &data[i * 64];
		}
    }

    start_timer();
    transfer_16to8copy(pY_Cur, &data[0 * 64], stride);
    transfer_16to8copy(pY_Cur + 8, &data[1 * 64], stride);
    transfer_16to8copy(pY_Cur + next_block, &data[2 * 64], stride);
    transfer_16to8copy(pY_Cur + 8 + next_block, &data[3 * 64], stride);
    transfer_16to8copy(pU_Cur, &data[4 * 64], stride2);
    transfer_16to8copy(pV_Cur, &data[5 * 64], stride2);
    stop_transfer_timer();

#if 0
	printf("(%d,%d)\n",x_pos,y_pos);
	printf("pY_Cur = [\n");
	for (j = 0; j < 8; j++)
        for (i = 0; i < 8; i++)
			printf(((i+1)%8)? "%5d " : "%5d\n", pY_Cur[j * stride + i]);
	printf("\n");
	printf("pY_Cur + 8 = [\n");
	for (j = 0; j < 8; j++)
        for (i = 0; i < 8; i++)
			printf(((i+1)%8)? "%5d " : "%5d\n", (pY_Cur+8)[j * stride + i]);
	printf("\n");
	printf("pY_Cur+ next_block = [\n");
	for (j = 0; j < 8; j++)
        for (i = 0; i < 8; i++)
			printf(((i+1)%8)? "%5d " : "%5d\n", (pY_Cur+ next_block)[j * stride + i]);
	printf("\n");
	printf("pY_Cur+ next_block +8= [\n");
	for (j = 0; j < 8; j++)
        for (i = 0; i < 8; i++)
			printf(((i+1)%8)? "%5d " : "%5d\n", (pY_Cur+ next_block+8)[j * stride + i]);
	printf("\n");
#endif
}

#define SIGN(X) (((X)>0)?1:-1)
#define ABS(X) (((X)>0)?(X):-(X))
static const uint32 roundtab[16] =
    { 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2 };

// decode an inter macroblock
void
decoder_mbinter(DECODER * dec,
                const MACROBLOCK * pMB,
                const uint32 x_pos,
                const uint32 y_pos,
                const uint32 acpred_flag,
                const uint32 cbp,
                Bitstream * bs,
                const uint32 quant, const uint32 rounding)
{
    uint32  stride = dec->edged_width;
    uint32  stride2 = stride / 2;
    uint32  next_block = stride * 8;
    uint32  i;
    uint32  iQuant = pMB->quant;
    uint8  *pY_Cur, *pU_Cur, *pV_Cur;
    int     uv_dx, uv_dy;

    pY_Cur = dec->cur.y + (y_pos << 4) * stride + (x_pos << 4);
    pU_Cur = dec->cur.u + (y_pos << 3) * stride2 + (x_pos << 3);
    pV_Cur = dec->cur.v + (y_pos << 3) * stride2 + (x_pos << 3);

    if (pMB->mode == MODE_INTER || pMB->mode == MODE_INTER_Q)
    {
        uv_dx = pMB->mvs[0].x;
        uv_dy = pMB->mvs[0].y;

        uv_dx = (uv_dx & 3) ? (uv_dx >> 1) | 1 : uv_dx / 2;
        uv_dy = (uv_dy & 3) ? (uv_dy >> 1) | 1 : uv_dy / 2;
    }
    else
    {
        int     sum;
        sum =
            pMB->mvs[0].x + pMB->mvs[1].x + pMB->mvs[2].x +
            pMB->mvs[3].x;
        uv_dx =
            (sum ==
             0 ? 0 : SIGN(sum) * (roundtab[ABS(sum) % 16] +
                                  (ABS(sum) / 16) * 2));

        sum =
            pMB->mvs[0].y + pMB->mvs[1].y + pMB->mvs[2].y +
            pMB->mvs[3].y;
        uv_dy =
            (sum ==
             0 ? 0 : SIGN(sum) * (roundtab[ABS(sum) % 16] +
                                  (ABS(sum) / 16) * 2));
    }

    start_timer();
    interpolate8x8_switch(dec->cur.y, dec->refn.y, 16 * x_pos,
                          16 * y_pos, pMB->mvs[0].x, pMB->mvs[0].y,
                          stride, rounding);
    interpolate8x8_switch(dec->cur.y, dec->refn.y, 16 * x_pos + 8,
                          16 * y_pos, pMB->mvs[1].x, pMB->mvs[1].y,
                          stride, rounding);
    interpolate8x8_switch(dec->cur.y, dec->refn.y, 16 * x_pos,
                          16 * y_pos + 8, pMB->mvs[2].x, pMB->mvs[2].y,
                          stride, rounding);
    interpolate8x8_switch(dec->cur.y, dec->refn.y, 16 * x_pos + 8,
                          16 * y_pos + 8, pMB->mvs[3].x, pMB->mvs[3].y,
                          stride, rounding);
    interpolate8x8_switch(dec->cur.u, dec->refn.u, 8 * x_pos, 8 * y_pos,
                          uv_dx, uv_dy, stride2, rounding);
    interpolate8x8_switch(dec->cur.v, dec->refn.v, 8 * x_pos, 8 * y_pos,
                          uv_dx, uv_dy, stride2, rounding);
    stop_comp_timer();

	int16* tmpBlock = NULL;

    for (i = 0; i < 6; i++)
    {
        if (cbp & (1 << (5 - i)))       // coded
        {
            memset(&block[i * 64], 0, 64 * sizeof(int16));      // clear

            start_timer();
            get_inter_block(bs, &block[i * 64]);
            stop_coding_timer();

            start_timer();
            dequant_inter(&data[i * 64], &block[i * 64], iQuant);
            stop_iquant_timer();

			//blocks[blockIdx++] = &data[i * 64];
			if(tmpBlock!=NULL)
			{
				start_timer();
				idct_dual(tmpBlock, &data[i * 64]);
				stop_idct_timer();
				tmpBlock = NULL;
			}
			else
			{
				tmpBlock = &data[i * 64];
			}
        }
    }
	if(tmpBlock!=NULL)
	{
		start_timer();
		idct(tmpBlock);
		stop_idct_timer();
	}

    start_timer();
    if (cbp & 32)
        transfer_16to8add(pY_Cur, &data[0 * 64], stride);
    if (cbp & 16)
        transfer_16to8add(pY_Cur + 8, &data[1 * 64], stride);
    if (cbp & 8)
        transfer_16to8add(pY_Cur + next_block, &data[2 * 64], stride);
    if (cbp & 4)
        transfer_16to8add(pY_Cur + 8 + next_block, &data[3 * 64],
                          stride);
    if (cbp & 2)
        transfer_16to8add(pU_Cur, &data[4 * 64], stride2);
    if (cbp & 1)
        transfer_16to8add(pV_Cur, &data[5 * 64], stride2);
    stop_transfer_timer();
}

/* ========================================================================= */
/*    Function : decode_video_packet_header()                                */
/*    Author   : CJ Tsai,                                                    */
/*    Date     : Feb/04/2003                                                 */
/* ------------------------------------------------------------------------- */
/*    The function handles HEX code, but does not make use of the redundant  */
/*    information.  It also does not handles B frame video packet headers.   */
/* ========================================================================= */
void    __inline
decode_video_packet_header(DECODER * dec, Bitstream * bs, xint fcode,
                           xint * quant)
{
    xint    resync_marker_length = (fcode) ? fcode + 16 : 17;

    BitstreamByteAlign(bs);
    BitstreamGetBits(bs, resync_marker_length); // resync marker
    BitstreamGetBits(bs, dec->nbits_mba);       // macroblock_number
    *quant = BitstreamGetBits(bs, dec->quant_bits);     // quant_scale
    if (BitstreamGetBit(bs))    // header_extension_code flag
    {
        /* modulo_time_base */
        while (BitstreamGetBits(bs, 1)) /* do nothing */ ;
        READ_MARKER();

        /* vop_time_increment (1-16 bits) */
        BitstreamGetBits(bs, dec->time_inc_bits);
        READ_MARKER();

        /* vop_prediction_type (2 bits) */
        BitstreamGetBits(bs, 2);

        /* intra_dc_vlc_thr */
        BitstreamGetBits(bs, 3);

        /* fcode */
        if (fcode)
            BitstreamGetBits(bs, 3);
    }
}

void
decoder_iframe(DECODER * dec, Bitstream * bs, xint quant,
               xint intra_dc_threshold)
{
    xint    resync_marker_length = 17;
    uint    mb_idx, slice_idx, slice_no;
    uint    extended_num_mb =
        (dec->mb_height + 1) * (dec->mb_width + 1);
    uint    x, y;

    /* we need to keep previous QP for intra_dc_vlc_thr.  CJ Tsai 03/02/2003 */
    xint    running_qp;

    memset(dec->slice, 0, extended_num_mb * sizeof(xint));
    slice_no = 1;
    mb_idx = 0;
    slice_idx = dec->mb_width + 2;
    running_qp = quant;

    for (y = 0; y < dec->mb_height; y++)
    {
        for (x = 0; x < dec->mb_width; x++, mb_idx++, slice_idx++)
        {
            MACROBLOCK *mb = &dec->mbs[mb_idx];
            uint32  mcbpc;
            uint32  cbpc;
            uint32  acpred_flag;
            uint32  cbpy;
            uint32  cbp;

            dec->slice[slice_idx] = slice_no;

            /* Decode one combined mode macroblock */
            mcbpc = get_mcbpc_intra(bs);
            mb->mode = mcbpc & 7;
            cbpc = (mcbpc >> 4);

            acpred_flag = BitstreamGetBit(bs);

            /*
               mb_type              Name
               not coded    -
               0                    INTER
               1                    INTER+Q
               3                    INTRA
               4                    INTRA+Q
               stuffing             -
             */
            if (mb->mode == MODE_STUFFING)
            {
                // DEBUG("-- STUFFING ?");
                continue;
            }

            cbpy = get_cbpy(bs, 1);
            cbp = (cbpy << 2) | cbpc;

            mb->quant = running_qp;
            if (mb->mode == MODE_INTRA_Q)
            {
                mb->quant += dquant_table[BitstreamGetBits(bs, 2)];
                if (mb->quant > 31)
                {
                    mb->quant = 31;
                }
                else if (mb->quant < 1)
                {
                    mb->quant = 1;
                }
            }

            decoder_mbintra(dec, mb, x, y, acpred_flag, cbp, bs,
                            running_qp, intra_dc_threshold);
            running_qp = mb->quant;

            /* Decode video packet header, if any */
            if (BitstreamShowBitsByteAlign(bs, resync_marker_length) ==
                1)
            {
                decode_video_packet_header(dec, bs, 0, &quant);
                running_qp = quant;
                slice_no++;
            }
        }
        slice_idx++;
    }
}

void
get_motion_vector(DECODER * dec, Bitstream * bs, int x, int y, int k,
                  VECTOR * mv, int fcode)
{
    int     scale_fac = 1 << (fcode - 1);
    int     high = (32 * scale_fac) - 1;
    int     low = ((-32) * scale_fac);
    int     range = (64 * scale_fac);

    VECTOR  pmv[4];
    int32   psad[4];

    int     mv_x, mv_y;
    int     pmv_x, pmv_y;

    get_pmvdata(dec->mbs, x, y, dec->mb_width, k, pmv, psad,
                dec->slice);

    pmv_x = pmv[0].x;
    pmv_y = pmv[0].y;

    mv_x = get_mv(bs, fcode);
    mv_y = get_mv(bs, fcode);

    mv_x += pmv_x;
    mv_y += pmv_y;

    if (mv_x < low)
    {
        mv_x += range;
    }
    else if (mv_x > high)
    {
        mv_x -= range;
    }

    if (mv_y < low)
    {
        mv_y += range;
    }
    else if (mv_y > high)
    {
        mv_y -= range;
    }

    mv->x = mv_x;
    mv->y = mv_y;
}

void
decoder_pframe(DECODER * dec, Bitstream * bs, xint rounding, xint quant,
               xint fcode, xint intra_dc_threshold)
{
    uint    resync_marker_length = fcode + 16;
    uint    mb_idx, slice_idx, slice_no;
    uint    extended_num_mb =
        (dec->mb_height + 1) * (dec->mb_width + 1);
    uint    x, y;

    uint32  mcbpc;
    uint32  cbpc;
    uint32  acpred_flag;
    uint32  cbpy;
    uint32  cbp;
    uint32  intra;

    /* we need to keep previous QP for intra_dc_vlc_thr.  CJ Tsai 03/02/2003 */
    xint    running_qp;

    image_swap(&dec->cur, &dec->refn);

    start_timer();
    image_setedges(&dec->refn, dec->edged_width, dec->edged_height,
                   dec->width, dec->height, dec->interlacing);
    stop_edges_timer();

    memset(dec->slice, 0, extended_num_mb * sizeof(xint));
    slice_no = 1;
    mb_idx = 0;
    slice_idx = dec->mb_width + 2;
    running_qp = 0;

    for (y = 0; y < dec->mb_height; y++)
    {
        for (x = 0; x < dec->mb_width; x++, mb_idx++, slice_idx++)
        {
            MACROBLOCK *mb = &dec->mbs[mb_idx];

            dec->slice[slice_idx] = slice_no;

            /* MB not_coded */
            if (!BitstreamGetBit(bs))   /* coded MB */
            {
                mcbpc = get_mcbpc_inter(bs);
                mb->mode = mcbpc & 7;
                cbpc = (mcbpc >> 4);
                acpred_flag = 0;

                intra = (mb->mode == MODE_INTRA
                         || mb->mode == MODE_INTRA_Q);

                if (intra)
                {
                    acpred_flag = BitstreamGetBit(bs);
                }

                if (mb->mode == MODE_STUFFING)
                {
                    // DEBUG("Stuffed MBs");
                    goto next_video_packet;
                }

                cbpy = get_cbpy(bs, intra);
                cbp = (cbpy << 2) | cbpc;

                mb->quant = (running_qp) ? running_qp : quant;
                if (mb->mode == MODE_INTER_Q
                    || mb->mode == MODE_INTRA_Q)
                {
                    mb->quant += dquant_table[BitstreamGetBits(bs, 2)];
                    if (mb->quant > 31)
                    {
                        mb->quant = 31;
                    }
                    else if (mb->quant < 1)
                    {
                        mb->quant = 1;
                    }
                }
                if (running_qp == 0)
                    running_qp = mb->quant;

                if (mb->mode == MODE_INTER || mb->mode == MODE_INTER_Q)
                {
                    get_motion_vector(dec, bs, x, y, 0, &mb->mvs[0],
                                      fcode);
                    mb->mvs[1].x = mb->mvs[2].x = mb->mvs[3].x =
                        mb->mvs[0].x;
                    mb->mvs[1].y = mb->mvs[2].y = mb->mvs[3].y =
                        mb->mvs[0].y;
                }
                else if (mb->mode == MODE_INTER4V)
                {
                    get_motion_vector(dec, bs, x, y, 0, &mb->mvs[0],
                                      fcode);
                    get_motion_vector(dec, bs, x, y, 1, &mb->mvs[1],
                                      fcode);
                    get_motion_vector(dec, bs, x, y, 2, &mb->mvs[2],
                                      fcode);
                    get_motion_vector(dec, bs, x, y, 3, &mb->mvs[3],
                                      fcode);
                }
                else            // MODE_INTRA, MODE_INTRA_Q
                {
                    mb->mvs[0].x = mb->mvs[1].x = mb->mvs[2].x =
                        mb->mvs[3].x = 0;
                    mb->mvs[0].y = mb->mvs[1].y = mb->mvs[2].y =
                        mb->mvs[3].y = 0;
                    decoder_mbintra(dec, mb, x, y, acpred_flag, cbp, bs,
                                    running_qp, intra_dc_threshold);
                    running_qp = mb->quant;
                    goto next_video_packet;
                }

                decoder_mbinter(dec, mb, x, y, acpred_flag, cbp, bs,
                                quant, rounding);
                running_qp = mb->quant;
            }
            else                /* not coded */
            {
                mb->mode = MODE_NOT_CODED;
                memset((void *) mb->mvs, 0, 4 * sizeof(VECTOR));

                // copy macroblock directly from ref to cur
                start_timer();

                transfer8x8_copy(dec->cur.y +
                                 (16 * y) * dec->edged_width + (16 * x),
                                 dec->refn.y +
                                 (16 * y) * dec->edged_width + (16 * x),
                                 dec->edged_width);

                transfer8x8_copy(dec->cur.y +
                                 (16 * y) * dec->edged_width + (16 * x +
                                                                8),
                                 dec->refn.y +
                                 (16 * y) * dec->edged_width + (16 * x +
                                                                8),
                                 dec->edged_width);

                transfer8x8_copy(dec->cur.y +
                                 (16 * y + 8) * dec->edged_width +
                                 (16 * x),
                                 dec->refn.y + (16 * y +
                                                8) * dec->edged_width +
                                 (16 * x), dec->edged_width);

                transfer8x8_copy(dec->cur.y +
                                 (16 * y + 8) * dec->edged_width +
                                 (16 * x + 8),
                                 dec->refn.y + (16 * y +
                                                8) * dec->edged_width +
                                 (16 * x + 8), dec->edged_width);

                transfer8x8_copy(dec->cur.u +
                                 (8 * y) * dec->edged_width / 2 +
                                 (8 * x),
                                 dec->refn.u +
                                 (8 * y) * dec->edged_width / 2 +
                                 (8 * x), dec->edged_width / 2);

                transfer8x8_copy(dec->cur.v +
                                 (8 * y) * dec->edged_width / 2 +
                                 (8 * x),
                                 dec->refn.v +
                                 (8 * y) * dec->edged_width / 2 +
                                 (8 * x), dec->edged_width / 2);

                stop_transfer_timer();
            }

          next_video_packet:
            /* Decode video packet header, if any.  We must check if there */
            /* is a valid stuffing pattern before the next resync_marker.  */
            /* Otherwise, it is possible that some uncoded MBs will be     */
            /* dropped by the decoder.                 CJ Tsai, Feb/7/2003 */
            if (!valid_stuffing(bs))
                continue;
            if (BitstreamShowBitsByteAlign(bs, resync_marker_length) ==
                1)
            {
                decode_video_packet_header(dec, bs, fcode, &quant);
                running_qp = 0;
                slice_no++;
            }
        }
        slice_idx++;
    }
}

xint
m4v_decode_frame(DEC_CTRL * xparam)
{
    DECODER *dec = (DECODER *) xparam->handle;
    Bitstream bs;
    uint32  rounding;
    uint32  quant;
    uint32  fcode;
    uint32  intra_dc_threshold;

    start_global_timer();

    BitstreamInit(&bs, xparam->bitstream, xparam->length);

    switch (BitstreamReadHeaders
            (&bs, dec, &rounding, &quant, &fcode, &intra_dc_threshold))
    {
    case P_VOP:
        xparam->type = 1;
        decoder_pframe(dec, &bs, rounding, quant, fcode,
                       intra_dc_threshold);
        break;

    case I_VOP:
        xparam->type = 0;
        decoder_iframe(dec, &bs, quant, intra_dc_threshold);
        break;

    case B_VOP:
        xparam->type = 2;
        break;

    case N_VOP:
        xparam->type = 3;
        break;

    default:
        return XVID_ERR_FAIL;
    }

    xparam->length =
        BitstreamPos(&bs) / 8 + ((BitstreamPos(&bs) % 8) > 0);
    xparam->timestamp = dec->timestamp;

    start_timer();
    image_output(&dec->cur, dec->width, dec->height, dec->edged_width,
                 xparam->image, xparam->stride);
    stop_conv_timer();
    stop_global_timer();

    return XVID_ERR_OK;
}
