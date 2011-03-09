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
  *  mbprediction.c                                                            *
  *                                                                            *
  *  Copyright (C) 2001 - Michael Militzer <isibaar@xvid.org>                  *
  *  Copyright (C) 2001 - Peter Ross <pross@cs.rmit.edu.au>                    *
  *                                                                            *
  *  For more information visit the XviD homepage: http://www.xvid.org         *
  *                                                                            *
  ******************************************************************************/

 /******************************************************************************
  *                                                                            *
  *  Revision history:                                                         *
  *                                                                            *
  *  15.12.2001 moved pmv displacement to motion estimation                    *
  *  30.11.2001	mmx cbp support                                                *
  *  17.11.2001 initial version                                                *
  *                                                                            *
  ******************************************************************************/

#include "mbprediction.h"
#include "mbfunctions.h"

#define ABS(X) (((X)>0)?(X):-(X))
#define DIV_DIV(A,B) ( (A) > 0 ? ((A)+((B)>>1))/(B) : ((A)-((B)>>1))/(B) )

static int __inline
rescale(int predict_quant, int current_quant, int coeff)
{
    return (coeff != 0) ? DIV_DIV((coeff) * (predict_quant),
                                  (current_quant)) : 0;
}

static const int16 default_acdc_values[15] = {
    1024,
    0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0
};

/*	get dc/ac prediction direction for a single block and place
	predictor values into MB->pred_values[j][..]
*/

void
predict_acdc(MACROBLOCK * pMBs,
             uint32 x, uint32 y, uint32 mb_width,
             uint32 block,
             int16 qcoeff[64],
             uint32 current_quant,
             int32 iDcScaler, int16 predictors[8], xint * slice)
{
    int16  *left, *top, *diag, *current;

    int32   left_quant = current_quant;
    int32   top_quant = current_quant;

    const int16 *pLeft = default_acdc_values;
    const int16 *pTop = default_acdc_values;
    const int16 *pDiag = default_acdc_values;

    xint    index = x + y * mb_width;   // current macroblock
    xint    slice_idx = index + y + mb_width + 2;
    xint   *acpred_direction = &pMBs[index].acpred_directions[block];
    xint    i;

    left = top = diag = current = 0;

    // grab left,top and diag macroblocks

    // left macroblock
    if ((slice[slice_idx - 1] == slice[slice_idx]) &&
        (pMBs[index - 1].mode == MODE_INTRA
         || pMBs[index - 1].mode == MODE_INTRA_Q))
    {
        left = pMBs[index - 1].pred_values[0];
        left_quant = pMBs[index - 1].quant;
        //DEBUGI("LEFT", *(left+MBPRED_SIZE));
    }

    // top macroblock
    if ((slice[slice_idx - mb_width - 1] == slice[slice_idx])
        && (pMBs[index - mb_width].mode == MODE_INTRA
            || pMBs[index - mb_width].mode == MODE_INTRA_Q))
    {
        top = pMBs[index - mb_width].pred_values[0];
        top_quant = pMBs[index - mb_width].quant;
    }

    // diag macroblock
    if ((slice[slice_idx - 2 - mb_width] == slice[slice_idx]) &&
        (pMBs[index - 1 - mb_width].mode == MODE_INTRA ||
         pMBs[index - 1 - mb_width].mode == MODE_INTRA_Q))
    {
        diag = pMBs[index - 1 - mb_width].pred_values[0];
    }

    current = pMBs[index].pred_values[0];

    // now grab pLeft, pTop, pDiag _blocks_

    switch (block)
    {
    case 0:
        if (left)
            pLeft = left + MBPRED_SIZE;
        if (top)
            pTop = top + (MBPRED_SIZE << 1);
        if (diag)
            pDiag = diag + 3 * MBPRED_SIZE;
        break;

    case 1:
        pLeft = current;
        left_quant = current_quant;
        if (top)
        {
            pTop = top + 3 * MBPRED_SIZE;
            pDiag = top + (MBPRED_SIZE << 1);
        }
        break;

    case 2:
        if (left)
        {
            pLeft = left + 3 * MBPRED_SIZE;
            pDiag = left + MBPRED_SIZE;
        }
        pTop = current;
        top_quant = current_quant;
        break;

    case 3:
        pLeft = current + (MBPRED_SIZE << 1);
        left_quant = current_quant;
        pTop = current + MBPRED_SIZE;
        top_quant = current_quant;
        pDiag = current;
        break;

    case 4:
        if (left)
            pLeft = left + (MBPRED_SIZE << 2);
        if (top)
            pTop = top + (MBPRED_SIZE << 2);
        if (diag)
            pDiag = diag + (MBPRED_SIZE << 2);
        break;

    case 5:
        if (left)
            pLeft = left + 5 * MBPRED_SIZE;
        if (top)
            pTop = top + 5 * MBPRED_SIZE;
        if (diag)
            pDiag = diag + 5 * MBPRED_SIZE;
        break;
    }

    //      determine ac prediction direction & ac/dc predictor
    //      place rescaled ac/dc predictions into predictors[] for later use

    if (ABS(pLeft[0] - pDiag[0]) < ABS(pDiag[0] - pTop[0]))
    {
        *acpred_direction = 1;  // vertical
        predictors[0] = DIV_DIV(pTop[0], (int16) iDcScaler);
        for (i = 1; i < 8; i++)
        {
            predictors[i] = rescale(top_quant, current_quant, pTop[i]);
        }
    }
    else
    {
        *acpred_direction = 2;  // horizontal
        predictors[0] = DIV_DIV(pLeft[0], (int16) iDcScaler);
        for (i = 1; i < 8; i++)
        {
            predictors[i] =
                rescale(left_quant, current_quant, pLeft[i + 7]);
        }
    }
}

/* decoder: add predictors to dct_codes[] and
   store current coeffs to pred_values[] for future prediction
*/
void
add_acdc(MACROBLOCK * pMB,
         uint32 block,
         int16 dct_codes[64], uint32 iDcScaler, int16 predictors[8])
{
    uint8   acpred_direction = pMB->acpred_directions[block];
    int16  *pCurrent = pMB->pred_values[block];
    uint32  i;

    dct_codes[0] += predictors[0];      // dc prediction
    pCurrent[0] = dct_codes[0] * (int16) iDcScaler;

    if (acpred_direction == 1)
    {
        for (i = 1; i < 8; i++)
        {
            int     level = dct_codes[i] + predictors[i];
            dct_codes[i] = level;
            pCurrent[i] = level;
            pCurrent[i + 7] = dct_codes[i * 8];
        }
    }
    else if (acpred_direction == 2)
    {
        for (i = 1; i < 8; i++)
        {
            int     level = dct_codes[i * 8] + predictors[i];
            dct_codes[i * 8] = level;
            pCurrent[i + 7] = level;
            pCurrent[i] = dct_codes[i];
        }
    }
    else
    {
        for (i = 1; i < 8; i++)
        {
            pCurrent[i] = dct_codes[i];
            pCurrent[i + 7] = dct_codes[i * 8];
        }
    }
}

/* ========================================================================= */
/*    Function : get_pmvdata()                                               */
/*    Author   : CJ Tsai,                                                    */
/*    Date     : Feb/04/2003                                                 */
/* ------------------------------------------------------------------------- */
/*    This code is based on the original get_pmvdata() of xvid.  However,    */
/*    Major modification is required in order to support video packet        */
/*    encoding.                                                              */
/*                                                                           */
/*    pmv are filled with:                                                   */
/*        [0]: Median (or whatever is correct in a special case)             */
/*        [1]: left neighbour                                                */
/*        [2]: top neighbour,                                                */
/*        [3]: topright neighbour,                                           */
/*        psad are filled with:                                              */
/*        [0]: minimum of [1] to [3]                                         */
/*        [1]: left neighbour's SAD	// [1] to [3] are actually not needed    */
/*        [2]: top neighbour's SAD                                           */
/*        [3]: topright neighbour's SAD                                      */
/* ========================================================================= */
int
get_pmvdata(MACROBLOCK * pMBs, xint x, xint y, xint x_dim, xint block,
            VECTOR * pmv, int32 * psad, xint * slice)
{
    int     xin1 = 0, xin2 = 0, xin3 = 0;
    int     yin1 = 0, yin2 = 0, yin3 = 0;
    int     vec1 = 0, vec2 = 0, vec3 = 0;

    static const VECTOR zeroMV = { 0, 0 };
    xint    index = x + y * x_dim;
    xint    slice_idx = index + y + x_dim + 2;

    /* top row of a video packet (special case) */
    if (slice)
    {
        if (slice[slice_idx - x_dim - 1] != slice[slice_idx]
            && block < 2)
        {
            if (block == 1)
            {
                if (y == 0 || x == x_dim - 1
                    || slice[slice_idx - x_dim] != slice[slice_idx])
                {
                    pmv[0] = pmv[1] = pMBs[index].mvs[0];
                    pmv[2] = pmv[3] = zeroMV;
                    psad[0] = psad[1] = pMBs[index].sad8[0];
                    psad[2] = psad[3] = MV_MAX_ERROR;
                    return 0;
                }
                else
                {
                    pmv[1] = pMBs[index].mvs[0];
                    pmv[2] = zeroMV;
                    pmv[3] = pMBs[index - x_dim + 1].mvs[2];
                    psad[1] = pMBs[index].sad8[0];
                    psad[2] = MV_MAX_ERROR;
                    psad[3] = pMBs[index - x_dim + 1].sad8[2];
                    goto compute_median;
                }
            }
            else if (y == 0 || x == x_dim - 1
                     || slice[slice_idx - x_dim] != slice[slice_idx])
            {
                if (slice[slice_idx - 1] != slice[slice_idx])   /* block == 0 here */
                {
                    pmv[0] = pmv[1] = pmv[2] = pmv[3] = zeroMV;
                    psad[0] = psad[1] = psad[2] = psad[3] =
                        MV_MAX_ERROR;
                    return 0;
                }
                else
                {
                    pmv[0] = pmv[1] = pMBs[index - 1].mvs[1];
                    pmv[2] = pmv[3] = zeroMV;
                    psad[0] = psad[1] = pMBs[index - 1].sad8[1];
                    psad[2] = psad[3] = MV_MAX_ERROR;
                    return 0;
                }
            }
            else
            {
                if (slice[slice_idx - 1] != slice[slice_idx])   /* block == 0 here */
                {
                    pmv[0] = pmv[1] = pMBs[index - x_dim + 1].mvs[2];
                    pmv[2] = pmv[3] = zeroMV;
                    psad[0] = psad[1] = pMBs[index - x_dim + 1].sad8[2];
                    psad[2] = psad[3] = MV_MAX_ERROR;
                    return 0;
                }
                else
                {
                    pmv[1] = pMBs[index - 1].mvs[1];
                    pmv[2] = zeroMV;
                    pmv[3] = pMBs[index - x_dim + 1].mvs[2];
                    psad[1] = pMBs[index - 1].sad8[1];
                    psad[2] = MV_MAX_ERROR;
                    psad[3] = pMBs[index - x_dim + 1].sad8[2];
                    goto compute_median;
                }
            }
        }
    }
    else
    {
        if (y == 0 && (block == 0 || block == 1))
        {
            if (block == 1)     /* 2nd block; has only a left neighbour */
            {
                pmv[0] = pmv[1] = pMBs[index].mvs[0];
                pmv[2] = pmv[3] = zeroMV;
                psad[0] = psad[1] = pMBs[index].sad8[0];
                psad[2] = psad[3] = MV_MAX_ERROR;
                return 0;
            }
            else if (x == 0)    /* block == 0 here */
            {
                pmv[0] = pmv[1] = pmv[2] = pmv[3] = zeroMV;
                psad[0] = psad[1] = psad[2] = psad[3] = MV_MAX_ERROR;
                return 0;
            }
            else                /* block == 0, but not horizontal slice boundary, there is a left neighboor */
            {
                pmv[0] = pmv[1] = pMBs[index - 1].mvs[1];
                pmv[2] = pmv[3] = zeroMV;
                psad[0] = psad[1] = pMBs[index - 1].sad8[1];
                psad[2] = psad[3] = MV_MAX_ERROR;
                return 0;
            }
        }
    }

    /* ------------------------------------------------------- */
    /*    MODE_INTER, vm18 page 48                             */
    /*    MODE_INTER4V vm18 page 51                            */
    /*                                                         */
    /*              (x, y-1)    (x+1,y-1)                      */
    /*              [   |   ]   [   |   ]                      */
    /*              [ 2 | 3 ]   [ 2 |   ]                      */
    /*                                                         */
    /*  (x-1,  y)    (x,  y)    (x+1, y)                       */
    /*  [   | 1 ]   [ 0 | 1 ]   [ 0 |   ]                      */
    /*  [   | 3 ]   [ 2 | 3 ]   [   |   ]                      */
    /* ------------------------------------------------------- */

    switch (block)
    {
    case 0:
        xin1 = x - 1;
        yin1 = y;
        vec1 = 1;               /* left */
        xin2 = x;
        yin2 = y - 1;
        vec2 = 2;               /* top */
        xin3 = x + 1;
        yin3 = y - 1;
        vec3 = 2;               /* top right */
        break;
    case 1:
        xin1 = x;
        yin1 = y;
        vec1 = 0;
        xin2 = x;
        yin2 = y - 1;
        vec2 = 3;
        xin3 = x + 1;
        yin3 = y - 1;
        vec3 = 2;
        break;
    case 2:
        xin1 = x - 1;
        yin1 = y;
        vec1 = 3;
        xin2 = x;
        yin2 = y;
        vec2 = 0;
        xin3 = x;
        yin3 = y;
        vec3 = 1;

        if (slice[slice_idx - 1] != slice[slice_idx])
            vec1 = 4;
        break;
    case 3:
        xin1 = x;
        yin1 = y;
        vec1 = 2;
        xin2 = x;
        yin2 = y;
        vec2 = 0;
        xin3 = x;
        yin3 = y;
        vec3 = 1;
        break;
    default:
        /* this can never happen */
        break;
    }

    if (xin1 < 0
        || vec1 == 4 /* || yin1 < 0  || xin1 >= (int32) x_dim */ )
    {
        pmv[1] = zeroMV;
        psad[1] = MV_MAX_ERROR;
    }
    else
    {
        pmv[1] = pMBs[xin1 + yin1 * x_dim].mvs[vec1];
        psad[1] = pMBs[xin1 + yin1 * x_dim].sad8[vec1];
    }

    if ( /* xin2 < 0 || */ yin2 < 0 /* || xin2 >= (int32) x_dim */ )
    {
        pmv[2] = zeroMV;
        psad[2] = MV_MAX_ERROR;
    }
    else
    {
        pmv[2] = pMBs[xin2 + yin2 * x_dim].mvs[vec2];
        psad[2] = pMBs[xin2 + yin2 * x_dim].sad8[vec2];
    }

    if ( /* xin3 < 0 || */ yin3 < 0 || xin3 >= (int32) x_dim)
    {
        pmv[3] = zeroMV;
        psad[3] = MV_MAX_ERROR;
    }
    else
    {
        pmv[3] = pMBs[xin3 + yin3 * x_dim].mvs[vec3];
        psad[3] = pMBs[xin2 + yin2 * x_dim].sad8[vec3];
    }

    if ((MVequal(pmv[1], pmv[2])) && (MVequal(pmv[1], pmv[3])))
    {
        pmv[0] = pmv[1];
        psad[0] = psad[1];
        return 1;
    }

  compute_median:

    /* median, minimum */
    pmv[0].x =
        MIN(MAX(pmv[1].x, pmv[2].x),
            MIN(MAX(pmv[2].x, pmv[3].x), MAX(pmv[1].x, pmv[3].x)));
    pmv[0].y =
        MIN(MAX(pmv[1].y, pmv[2].y),
            MIN(MAX(pmv[2].y, pmv[3].y), MAX(pmv[1].y, pmv[3].y)));
    psad[0] = MIN(MIN(psad[1], psad[2]), psad[3]);
    return 0;
}
