#ifndef _MBPREDICTION_H_
#define _MBPREDICTION_H_

#include "m4vdec_api.h"
#include "global.h"

#define MIN(X, Y) ((X)<(Y)?(X):(Y))
#define MAX(X, Y) ((X)>(Y)?(X):(Y))

#define MV_MAX_ERROR	(4096 * 256)

#define MVequal(A,B) ( ((A).x)==((B).x) && ((A).y)==((B).y) )

void    predict_acdc(MACROBLOCK * pMBs, uint32 x, uint32 y,
                     uint32 mb_width, uint32 block, int16 qcoeff[64],
                     uint32 current_quant, int32 iDcScaler,
                     int16 predictors[8], xint * slice);
void    add_acdc(MACROBLOCK * pMB, uint32 block, int16 dct_codes[64],
                 uint32 iDcScaler, int16 predictors[8]);
int     get_pmvdata(MACROBLOCK * pMBs, xint x, xint y, xint nMB_width,
                    xint block, VECTOR * pmv, int32 * psad,
                    xint * slice);

#endif /* _MBPREDICTION_H_ */
