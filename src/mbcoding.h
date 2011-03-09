#ifndef _MB_CODING_H_
#define _MB_CODING_H_

#include "global.h"
#include "bitstream.h"

void    init_vlc_tables(void);

int     get_mcbpc_intra(Bitstream * bs);
int     get_mcbpc_inter(Bitstream * bs);
int     get_cbpy(Bitstream * bs, int intra);
int     get_mv(Bitstream * bs, int fcode);

int     get_dc_dif(Bitstream * bs, uint32 dc_size);
int     get_dc_size_lum(Bitstream * bs);
int     get_dc_size_chrom(Bitstream * bs);

void    get_intra_block(Bitstream * bs, int16 * block, int direction,
                        int coeff);
void    get_inter_block(Bitstream * bs, int16 * block);

#endif /* _MB_CODING_H_ */
