#ifndef _GLOBAL_H_
#define _GLOBAL_H_

#include "metypes.h"

typedef struct
{
    int     x;
    int     y;
} VECTOR;

typedef struct
{
    int     mode;               // macroblock mode
    VECTOR  mvs[4];
} MVBLOCKHINT;

typedef struct
{
    int     intra;              // frame intra choice
    int     fcode;              // frame fcode
    MVBLOCKHINT *block;         // caller-allocated array of block hints (mb_width * mb_height)
} MVFRAMEHINT;

typedef struct
{
    int     rawhints;           // if set, use MVFRAMEHINT, else use compressed buffer

    MVFRAMEHINT mvhint;
    void   *hintstream;         // compressed hint buffer
    int     hintlength;         // length of buffer (bytes)
} HINTINFO;

// error
#define XVID_ERR_FAIL		-1
#define XVID_ERR_OK			0
#define	XVID_ERR_MEMORY		1
#define XVID_ERR_FORMAT		2

/* --- macroblock stuff --- */
#define MODE_INTER		0
#define MODE_INTER_Q	1
#define MODE_INTER4V	2
#define	MODE_INTRA		3
#define MODE_INTRA_Q	4
#define MODE_STUFFING	7
#define MODE_NOT_CODED	16

typedef struct
{
    uint32  MTB;
    uint32  bufa;
    uint32  bufb;
    uint32  buf;
    uint32  pos;
    uint32 *tail;
    uint32 *start;
    uint32  length;
}
Bitstream;

#define MBPRED_SIZE  15

typedef struct
{
    /* decoder/encoder */
    VECTOR  mvs[4];
    uint32  sad8[4];            /* SAD values for inter4v-VECTORs */
    uint32  sad16;              /* SAD value for inter-VECTOR     */

    short int pred_values[6][MBPRED_SIZE];
    int     acpred_directions[6];

    int     mode;
    int     quant;              /* absolute quant */

    /* encoder specific */
    VECTOR  pmvs[4];
    int     dquant;
    int     cbp;

} MACROBLOCK;

static __inline int32
get_dc_scaler(int32 quant, uint32 lum)
{
    int32   dc_scaler;

    if (quant > 0 && quant < 5)
    {
        dc_scaler = 8;
        return dc_scaler;
    }

    if (quant < 25 && !lum)
    {
        dc_scaler = (quant + 13) >> 1;
        return dc_scaler;
    }

    if (quant < 9)
    {
        dc_scaler = quant << 1;
        return dc_scaler;
    }

    if (quant < 25)
    {
        dc_scaler = quant + 8;
        return dc_scaler;
    }

    if (lum)
    {
        dc_scaler = (quant << 1) - 16;
    }
    else
    {
        dc_scaler = quant - 6;
    }

    return dc_scaler;
}

#endif /* _GLOBAL_H_ */
