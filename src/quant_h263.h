#ifndef _QUANT_H263_H_
#define _QUANT_H263_H_

#include "metypes.h"

void    quant_intra(int16 * coeff, const int16 * data,
                    const uint32 quant, const uint32 dcscalar);
uint32  quant_inter(int16 * coeff, const int16 * data,
                    const uint32 quant);
void    dequant_intra(int16 * data, const int16 * coeff,
                      const uint32 quant, const uint32 dcscalar);
void    dequant_inter(int16 * data, const int16 * coeff,
                      const uint32 quant);

#endif /* _QUANT_H263_H_ */
