#ifndef _DECODER_H_
#define _DECODER_H_

#ifdef __cplusplus
extern  "C"
{
#endif

#include "global.h"
#include "image.h"

    typedef struct
    {
        // ---- Input parameters -------------------------------
        uint8  *bitstream;      // bitstream data
        uint8  *image;          // decoded YCbCr 4:2:0 frame buffer
        xint    stride;         // "width" of the frame buffer

        // ---- Output parameters ------------------------------
        xint    type;           // frame type (I-frame, or P-frame)
        uint32  timestamp;      // timestamp of the frame
        xint    width;          // video frame width
        xint    height;         // video frame height

        // ---- In/Out parameters ------------------------------
        xint    length;         // size (bytes) of the bitstream

        // ---- Internal parameters ----------------------------
        void   *handle;         // a pointer to a DECODER structure
    } DEC_CTRL;

    typedef struct
    {
        // bitstream
        uint32  shape;
        uint32  time_inc_bits;
        uint32  quant_bits;
        uint32  quant_type;
        uint32  quarterpel;

        uint32  interlacing;
        uint32  top_field_first;
        uint32  alternate_vertical_scan;

        // image
        uint32  width;
        uint32  height;
        uint32  edged_width;
        uint32  edged_height;

        IMAGE   cur;
        IMAGE   refn;
        IMAGE   refh;
        IMAGE   refv;
        IMAGE   refhv;

        // macroblock
        uint    mb_width;
        uint    mb_height;
        uint    num_mb;
        uint    nbits_mba;      /* number of bits required for MB address.  CJT */
        MACROBLOCK *mbs;

        // for video packet
        xint   *slice;

        // timestamp of current frame (in millisecond)
        uint32  timestamp;
        uint32  time_inc_resolution;
        uint32  decoder_clock;
    } DECODER;

    xint    m4v_init_decoder(DEC_CTRL * xparam, uint8 * video_header,
                             xint header_size);
    xint    m4v_decode_frame(DEC_CTRL * xparam);
    xint    m4v_free_decoder(DEC_CTRL * xparam);

#ifdef __cplusplus
}
#endif

#endif                          /* _DECODER_H_ */
