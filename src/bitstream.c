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
  *  bitstream.c                                                               *
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
  *  26.03.2002 interlacing support
  *  03.03.2002 qmatrix writing												   *
  *  03.03.2002 merged BITREADER and BITWRITER								   *
  *	 30.02.2002	intra_dc_threshold support									   *
  *	 04.12.2001	support for additional headers								   *
  *	 16.12.2001	inital version                                           	   *
  *																			   *
  ******************************************************************************/

#include "bitstream.h"
#include "zigzag.h"

#define BSWAP(a) (a = ((a>>24)&0xff) | (((a>>16)&0xff)<<8) | \
                      (((a>>8)&0xff)<<16) | ((a&0xff)<<24))

static const uint32 intra_dc_threshold_table[] = {
    32,                         /* never use */
    13,
    15,
    17,
    19,
    21,
    23,
    1,
};

/* initialise bitstream structure */
void
BitstreamInit(Bitstream *const bs, void *const bitstream, uint32 length)
{
    uint32  tmp;

    bs->start = bs->tail = (uint32 *) bitstream;
    tmp = *(uint32 *) bitstream;

#ifndef ARCH_IS_BIG_ENDIAN
    BSWAP(tmp);
#endif
    bs->bufa = tmp;
    tmp = *((uint32 *) bitstream + 1);

#ifndef ARCH_IS_BIG_ENDIAN
    BSWAP(tmp);
#endif
    bs->bufb = tmp;

    bs->buf = 0;
    bs->pos = 0;
    bs->length = length;
}

/* reset bitstream state */
void
BitstreamReset(Bitstream * const bs)
{
    uint32  tmp;

    bs->tail = bs->start;

    tmp = *bs->start;
#ifndef ARCH_IS_BIG_ENDIAN
    BSWAP(tmp);
#endif
    bs->bufa = tmp;

    tmp = *(bs->start + 1);
#ifndef ARCH_IS_BIG_ENDIAN
    BSWAP(tmp);
#endif
    bs->bufb = tmp;

    bs->buf = 0;
    bs->pos = 0;
}

/* skip n bits forward in bitstream */
void
BitstreamSkip(Bitstream * const bs, const uint32 bits)
{
    bs->pos += bits;

    if (bs->pos >= 32)
    {
        uint32  tmp;

        bs->bufa = bs->bufb;
        tmp = *((uint32 *) bs->tail + 2);

#ifndef ARCH_IS_BIG_ENDIAN
        BSWAP(tmp);
#endif
        bs->bufb = tmp;
        bs->tail++;
        bs->pos -= 32;
    }
}

/*	flush the bitstream & return length (unit bytes)
	NOTE: assumes no futher bitstream functions will be called.
 */
uint32
BitstreamLength(Bitstream * const bs)
{
    uint32  len = (uint32) bs->tail - (uint32) bs->start;

    if (bs->pos)
    {
        uint32  b = bs->buf;
#ifndef ARCH_IS_BIG_ENDIAN
        BSWAP(b);
#endif
        *bs->tail = b;

        len += (bs->pos + 7) / 8;
    }

    return len;
}

/* move bitstream position forward by "bits" bits */
void
BitstreamForward(Bitstream * const bs, const uint32 bits)
{
    bs->pos += bits;

    if (bs->pos >= 32)
    {
        uint32  b = bs->buf;
#ifndef ARCH_IS_BIG_ENDIAN
        BSWAP(b);
#endif
        *bs->tail++ = b;
        bs->buf = 0;
        bs->pos -= 32;
    }
}

/*
decode headers
returns coding_type, or -1 if error
*/
int
BitstreamReadHeaders(Bitstream * bs, DECODER * dec, uint32 * rounding,
                     uint32 * quant, uint32 * fcode,
                     uint32 * intra_dc_threshold)
{
    uint32  vol_ver_id;
    uint32  time_inc_resolution;
    uint32  coding_type;
    uint32  start_code;

    do
    {
        BitstreamByteAlignNoForceStuffing(bs);
        start_code = BitstreamShowBits(bs, 32);

        if (start_code == VISOBJSEQ_START_CODE)
        {
            // DEBUG("visual_object_sequence");
            BitstreamSkip(bs, 32); /* visual_object_sequence_start_code */
            BitstreamSkip(bs, 8);  /* profile_and_level_indication      */
        }
        else if (start_code == VISOBJSEQ_STOP_CODE)
        {
            BitstreamSkip(bs, 32); /* visual_object_sequence_stop_code  */
        }
        else if (start_code == VISOBJ_START_CODE)
        {
            // DEBUG("visual_object");
            BitstreamGetBits(bs, 32); /* visual_object_start_code       */
            if (BitstreamGetBit(bs))  /* is_visual_object_identified    */
            {
                vol_ver_id = BitstreamGetBits(bs, 4); /* vis_obj_ver_id */
                BitstreamSkip(bs, 3);         /* visual_object_priority */
            }
            else
            {
                vol_ver_id = 1;
            }

            if (BitstreamShowBits(bs, 4) != VISOBJ_TYPE_VIDEO)
            {
                // DEBUG("visual_object_type != video");
                return -1;
            }
            BitstreamSkip(bs, 4);

            if (BitstreamGetBit(bs))    /* video_signal_type */
            {
                // DEBUG("+ video_signal_type");
                BitstreamSkip(bs, 3);   /* video_format      */
                BitstreamSkip(bs, 1);   /* video_range       */
                if (BitstreamGetBit(bs))   /* color_description */
                {
                    // DEBUG("+ color_description");
                    BitstreamSkip(bs, 8);  /* color_primaries          */
                    BitstreamSkip(bs, 8);  /* transfer_characteristics */
                    BitstreamSkip(bs, 8);  /* matrix_coefficients      */
                }
            }
        }
        else if ((start_code & ~0x1f) == VIDOBJ_START_CODE)
        {
            BitstreamSkip(bs, 32);    /* video_object_start_code */
        }
        else if ((start_code & ~0xf) == VIDOBJLAY_START_CODE)
        {
            // DEBUG("video_object_layer");
            BitstreamSkip(bs, 32);    /* video_object_layer_start_code */

            BitstreamSkip(bs, 1);     /* random_accessible_vol         */

            /* video_object_type_indication */
            if (BitstreamShowBits(bs, 8) != VIDOBJLAY_TYPE_SIMPLE &&
                BitstreamShowBits(bs, 8) != VIDOBJLAY_TYPE_CORE &&
                BitstreamShowBits(bs, 8) != VIDOBJLAY_TYPE_MAIN &&
                BitstreamShowBits(bs, 8) != 0)   /* buggy DIVX code */
            {
                // DEBUG1("video_object_type_indication not supported",
                //       BitstreamShowBits(bs, 8));
                return -1;
            }
            BitstreamSkip(bs, 8);

            if (BitstreamGetBit(bs))  /* is_object_layer_identifier */
            {
                // DEBUG("+ is_object_layer_identifier");
                vol_ver_id = BitstreamGetBits(bs, 4); /* vid_obj_layer_verid */
                BitstreamSkip(bs, 3);   /* video_object_layer_priority */
            }
            else
            {
                vol_ver_id = 1;
            }
            //DEBUGI("vol_ver_id", vol_ver_id);

            /* read aspect_ratio_info */
            if (BitstreamGetBits(bs, 4) == VIDOBJLAY_AR_EXTPAR)
            {
                // DEBUG("+ aspect_ratio_info");
                BitstreamSkip(bs, 8);   /* par_width  */
                BitstreamSkip(bs, 8);   /* par_height */
            }

            /* read vol_control_parameters */
            if (BitstreamGetBit(bs))
            {
                // DEBUG("+ vol_control_parameters");
                BitstreamSkip(bs, 2);   /* chroma_format */
                BitstreamSkip(bs, 1);   /* low_delay     */
                if (BitstreamGetBit(bs))    /* vbv_parameters */
                {
                    // DEBUG("+ vbv_parameters");
                    BitstreamSkip(bs, 15); /* first_half_bitrate */
                    READ_MARKER();
                    BitstreamSkip(bs, 15); /* latter_half_bitrate */
                    READ_MARKER();
                    BitstreamSkip(bs, 15); /* first_half_vbv_buf_size */
                    READ_MARKER();
                    BitstreamSkip(bs, 3);  /* latter_half_vbv_buf_size */
                    BitstreamSkip(bs, 11); /* first_half_vbv_occupancy */
                    READ_MARKER();
                    BitstreamSkip(bs, 15); /* latter_half_vbv_occupancy */
                    READ_MARKER();
                }
            }

            dec->shape = BitstreamGetBits(bs, 2);  /* vol_shape */
            // DEBUG1("shape", dec->shape);

            if (dec->shape==VIDOBJLAY_SHAPE_GRAYSCALE && vol_ver_id!=1)
            {
                BitstreamSkip(bs, 4);  /* vol_shape_extension */
            }

            READ_MARKER();

            /* vop_time_increment_resolution */
            dec->time_inc_resolution = BitstreamGetBits(bs, 16);
            time_inc_resolution = dec->time_inc_resolution - 1;
            if (time_inc_resolution > 0)
            {
                dec->time_inc_bits = log2bin(time_inc_resolution);
            }
            else
            {
                /* dec->time_inc_bits = 0; */
                /* for "old" xvid compatibility, set time_inc_bits = 1 */
                dec->time_inc_bits = 1;
            }

            READ_MARKER();

            if (BitstreamGetBit(bs)) /* fixed_vop_rate */
            {
                BitstreamSkip(bs, dec->time_inc_bits); /* fixed_vop_time_inc */
            }

            if (dec->shape != VIDOBJLAY_SHAPE_BINARY_ONLY)
            {
                if (dec->shape == VIDOBJLAY_SHAPE_RECTANGULAR)
                {
                    READ_MARKER();
                    dec->width = BitstreamGetBits(bs, 13);  /* vol_width */
                    //DEBUGI("width", width);
                    READ_MARKER();
                    dec->height = BitstreamGetBits(bs, 13); /* vol_height */
                    //DEBUGI("height", height);
                    READ_MARKER();
                }

                if ((dec->interlacing = BitstreamGetBit(bs)) != 0)
                {
                    // DEBUG("vol: interlacing");
                }

                if (!BitstreamGetBit(bs)) /* obmc_disable */
                {
                    // DEBUG("IGNORED/TODO: !obmc_disable");
                    // TODO
                    // fucking divx4.02 has this enabled
                }

                /* read sprite_enable */
                if (BitstreamGetBits(bs, (vol_ver_id == 1 ? 1 : 2)))
                {
                    // DEBUG("sprite_enable; not supported");
                    return -1;
                }

                if (vol_ver_id != 1
                    && dec->shape != VIDOBJLAY_SHAPE_RECTANGULAR)
                {
                    BitstreamSkip(bs, 1); /* sadct_disable */
                }

                if (BitstreamGetBit(bs))  /* not_8_bit     */
                {
                    // DEBUG("+ not_8_bit [IGNORED/TODO]");
                    dec->quant_bits = BitstreamGetBits(bs, 4); /* quant_precision */
                    BitstreamSkip(bs, 4);  /* bits_per_pixel */
                }
                else
                {
                    dec->quant_bits = 5;
                }

                if (dec->shape == VIDOBJLAY_SHAPE_GRAYSCALE)
                {
                    BitstreamSkip(bs, 1);    /* no_gray_quant_update */
                    BitstreamSkip(bs, 1);    /* composition_method   */
                    BitstreamSkip(bs, 1);    /* linear_composition   */
                }

                /* H.263 quantizer or mpeg-4 quantizer */
                dec->quant_type = BitstreamGetBit(bs);
                if (dec->quant_type != 0)
                {
                    // DEBUG
                    //    ("Simple profile only allows H.263 quantizer.");
                    return -1;
                }

                if (vol_ver_id != 1)
                {
                    dec->quarterpel = BitstreamGetBit(bs); /* quarter_sampe */
                    if (dec->quarterpel)
                    {
                        // DEBUG("IGNORED/TODO: quarter_sample");
                    }
                }
                else
                {
                    dec->quarterpel = 0;
                }

                if (!BitstreamGetBit(bs)) /* complexity_estimation_disable */
                {
                    // DEBUG("TODO: complexity_estimation header");
                    // TODO
                    return -1;
                }

                if (!BitstreamGetBit(bs)) /* resync_marker_disable */
                {
                    // DEBUG("IGNORED/TODO: !resync_marker_disable");
                    // TODO
                    //printf("...todo resync process\n");
                }

                if (BitstreamGetBit(bs)) /* data_partitioned */
                {
                    // DEBUG("Data partitioning is not supported");
                    return -1;
                }

                if (vol_ver_id != 1)
                {
                    if (BitstreamGetBit(bs)) /* newpred_enable */
                    {
                        // DEBUG("+ newpred_enable");
                        BitstreamSkip(bs, 2); /* requested_upstream_message_type */
                        BitstreamSkip(bs, 1); /* newpred_segment_type */
                    }
                    if (BitstreamGetBit(bs))  /* reduced_resolution_vop_enable */
                    {
                        // DEBUG("TODO: reduced_resolution_vop_enable");
                        // TODO
                        return -1;
                    }
                }

                if (BitstreamGetBit(bs)) /* scalability */
                {
                    // TODO
                    // DEBUG("TODO: scalability");
                    return -1;
                }
            }
            else /* dec->shape == BINARY_ONLY */
            {
                if (vol_ver_id != 1)
                {
                    if (BitstreamGetBit(bs)) /* scalability */
                    {
                        // TODO
                        // DEBUG("TODO: scalability");
                        return -1;
                    }
                }
                BitstreamSkip(bs, 0); /* resync_marker_disable */
            }

            BitstreamByteAlign(bs);
        }
        else if (start_code == GRPOFVOP_START_CODE)
        {
            // DEBUG("group_of_vop");
            BitstreamSkip(bs, 32); /* group_vop_start_codes */
            {
                int     hours, minutes, seconds;
                hours = BitstreamGetBits(bs, 5);   /* time_code 18bits */
                minutes = BitstreamGetBits(bs, 6);
                READ_MARKER();
                seconds = BitstreamGetBits(bs, 6);

                dec->decoder_clock =
                    hours * 3600 + minutes * 60 + seconds;
            }
            BitstreamSkip(bs, 1); /* closed_gov  */
            BitstreamSkip(bs, 1); /* broken_link */
        }
        else if (start_code == VOP_START_CODE)
        {
            uint32  time_tick = 0;

            // DEBUG("vop_start_code");
            BitstreamSkip(bs, 32);      /* vop_start_code */

            coding_type = BitstreamGetBits(bs, 2);  /* vop_coding_type */
            // DEBUG1("coding_type", coding_type);

            /* modulo time base */
            while (BitstreamGetBit(bs) != 0)
            {
                dec->decoder_clock++;
            }

            READ_MARKER();

            // DEBUG1("time_inc_bits", dec->time_inc_bits);
            // DEBUG1("vop_time_incr", BitstreamShowBits(bs, dec->time_inc_bits));
            if (dec->time_inc_bits)
            {
                time_tick = BitstreamGetBits(bs, dec->time_inc_bits);
            }
            dec->timestamp =
                (time_tick * 1000) / dec->time_inc_resolution +
                dec->decoder_clock * 1000;

            READ_MARKER();

            if (!BitstreamGetBit(bs)) /* vop_coded */
            {
                return N_VOP;
            }

            /* if (newpred_enable)
               {
               }
             */

            if (coding_type != I_VOP)
            {
                *rounding = BitstreamGetBit(bs);    /* rounding_type */
                // DEBUG1("rounding", *rounding);
            }

            /* if (reduced_resolution_enable)
               {
               }
             */

            if (dec->shape != VIDOBJLAY_SHAPE_RECTANGULAR)
            {
                uint32  width, height;
                uint32  horiz_mc_ref, vert_mc_ref;

                width = BitstreamGetBits(bs, 13);
                READ_MARKER();
                height = BitstreamGetBits(bs, 13);
                READ_MARKER();
                horiz_mc_ref = BitstreamGetBits(bs, 13);
                READ_MARKER();
                vert_mc_ref = BitstreamGetBits(bs, 13);
                READ_MARKER();

                // DEBUG2("vop_width/height", width, height);
                // DEBUG2("ref             ", horiz_mc_ref, vert_mc_ref);

                BitstreamSkip(bs, 1);   /* change_conv_ratio_disable */
                if (BitstreamGetBit(bs))   /* vop_constant_alpha */
                {
                    BitstreamSkip(bs, 8);  /* vop_constant_alpha_value */
                }
            }

            if (dec->shape != VIDOBJLAY_SHAPE_BINARY_ONLY)
            {
                /* intra_dc_vlc_threshold */
                *intra_dc_threshold =
                    intra_dc_threshold_table[BitstreamGetBits(bs, 3)];
            }

            *quant = BitstreamGetBits(bs, dec->quant_bits); /* vop_quant */
            // DEBUG1("quant", *quant);

            if (coding_type != I_VOP)
            {
                *fcode = BitstreamGetBits(bs, 3); /* fcode_forward */
            }

            /*
            if (coding_type == B_VOP)
            {
                *fcode_backward = BitstreamGetBits(bs, 3);
            }
            */

            return coding_type;
        }
        else if (start_code == USERDATA_START_CODE)
        {
            // DEBUG("user_data");
            BitstreamSkip(bs, 32);  /* user_data_start_code */
        }
        else /* start_code == ? */
        {
            if (BitstreamShowBits(bs, 24) == 0x000001)
            {
                // DEBUG1("*** WARNING: unknown start_code",
                //       BitstreamShowBits(bs, 32));
            }
            BitstreamSkip(bs, 8);
        }
        /* NextStartCode(); */
    }
    while ((BitstreamPos(bs) >> 3) < bs->length);

    // DEBUG("*** WARNING: no vop_start_code found");
    return -1; /* ignore it */
}
