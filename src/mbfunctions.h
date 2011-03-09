/**************************************************************************
 *
 *  Modifications:
 *
 *  29.03.2002 removed MBFieldToFrame - no longer used (transfers instead)
 *  26.03.2002 interlacing support
 *  02.12.2001 motion estimation/compensation split
 *  16.11.2001 const/uint32 changes to MBMotionEstComp()
 *  26.08.2001 added inter4v_mode parameter to MBMotionEstComp()
 *
 *  Michael Militzer <isibaar@videocoding.de>
 *
 **************************************************************************/

#ifndef _ENCORE_BLOCK_H
#define _ENCORE_BLOCK_H

#include "bitstream.h"

/** MBMotionCompensation **/
void    MBMotionCompensation(MACROBLOCK * const pMB,
                             const uint32 j,
                             const uint32 i,
                             const IMAGE * const pRef,
                             const IMAGE * const pRefH,
                             const IMAGE * const pRefV,
                             const IMAGE * const pRefHV,
                             IMAGE * const pCurrent,
                             int16 dct_codes[6 * 64],
                             const uint32 width,
                             const uint32 height,
                             const uint32 edged_width,
                             const uint32 rounding);

/** interlacing **/
uint32  MBDecideFieldDCT(int16 data[6 * 64]);   /* <- decide whether to use field-based DCT
                                                   for interlacing */
void    MBFrameToField(int16 data[6 * 64]);     /* de-interlace vertical Y blocks */

/** MBCoding.c **/
void    PutDctDcLumaChroma(Bitstream * bs, xint q_idx, xint idx);
void    GetCBPYVLC(uint32 cbpy, xint * code, xint * len);
void    DPCodeCoeff(Bitstream * bs, int16 qcoeff[64],
                    int acpred_directions, uint16 intra);
#endif
