#include <stdlib.h>
#include "bitstream.h"
#include "zigzag.h"
#include "vlc_codes.h"
#include "mbcoding.h"

#include "mbfunctions.h"

#define ABS(X) (((X)>0)?(X):-(X))
#define CLIP(X,A) (X > A) ? (A) : (X)

VLC     DCT3Dintra[4096];
VLC     DCT3Dinter[4096];

static int16 clip_table[4096];

void
init_vlc_tables(void)
{
    int32   i;
    VLC    *vlc1, *vlc2;

    vlc1 = DCT3Dintra;
    vlc2 = DCT3Dinter;

    // initialize the clipping table
    for (i = -2048; i < 2048; i++)
    {
        clip_table[i + 2048] = (int16) i;
        if (i < -255)
            clip_table[i + 2048] = -255;
        if (i > 255)
            clip_table[i + 2048] = 255;
    }

    for (i = 0; i < 4096; i++)
    {
        if (i >= 512)
        {
            *vlc1 = DCT3Dtab3[(i >> 5) - 16];
            *vlc2 = DCT3Dtab0[(i >> 5) - 16];
        }
        else if (i >= 128)
        {
            *vlc1 = DCT3Dtab4[(i >> 2) - 32];
            *vlc2 = DCT3Dtab1[(i >> 2) - 32];
        }
        else if (i >= 8)
        {
            *vlc1 = DCT3Dtab5[i - 8];
            *vlc2 = DCT3Dtab2[i - 8];
        }
        else
        {
            *vlc1 = ERRtab[i];
            *vlc2 = ERRtab[i];
        }

        vlc1++;
        vlc2++;
    }
    DCT3D[0] = DCT3Dinter;
    DCT3D[1] = DCT3Dintra;
}

/***************************************************************
 * decoding stuff starts here                                  *
 ***************************************************************/

int
get_mcbpc_intra(Bitstream * bs)
{
    uint32  index;

    while ((index = BitstreamShowBits(bs, 9)) == 1)
    {
        BitstreamSkip(bs, 9);
    }
    index >>= 3;
    BitstreamSkip(bs, mcbpc_intra_table[index].len);
    return mcbpc_intra_table[index].code;
}

int
get_mcbpc_inter(Bitstream * bs)
{
    uint32  index;

    while ((index = CLIP(BitstreamShowBits(bs, 9), 256)) == 1)
    {
        BitstreamSkip(bs, 9);
    }

    BitstreamSkip(bs, mcbpc_inter_table[index].len);
    return mcbpc_inter_table[index].code;
}

int
get_cbpy(Bitstream * bs, int intra)
{
    int     cbpy;
    uint32  index = BitstreamShowBits(bs, 6);

    BitstreamSkip(bs, cbpy_table[index].len);
    cbpy = cbpy_table[index].code;

    if (!intra)
        cbpy = 15 - cbpy;

    return cbpy;
}

int
get_mv_data(Bitstream * bs)
{
    uint32  index;

    if (BitstreamGetBit(bs))
        return 0;

    index = BitstreamShowBits(bs, 12);
    if (index >= 512)
    {
        index = (index >> 8) - 2;
        BitstreamSkip(bs, TMNMVtab0[index].len);
        return TMNMVtab0[index].code;
    }

    if (index >= 128)
    {
        index = (index >> 2) - 32;
        BitstreamSkip(bs, TMNMVtab1[index].len);
        return TMNMVtab1[index].code;
    }

    index -= 4;

    BitstreamSkip(bs, TMNMVtab2[index].len);
    return TMNMVtab2[index].code;
}

int
get_mv(Bitstream * bs, int fcode)
{
    int     data;
    int     res;
    int     mv;
    int     scale_fac = 1 << (fcode - 1);

    data = get_mv_data(bs);

    if (scale_fac == 1 || data == 0)
        return data;

    res = BitstreamGetBits(bs, fcode - 1);
    mv = ((ABS(data) - 1) * scale_fac) + res + 1;

    return data < 0 ? -mv : mv;
}

int
get_dc_dif(Bitstream * bs, uint32 dc_size)
{
    int     code = BitstreamGetBits(bs, dc_size);
    int     msb = code >> (dc_size - 1);

    if (msb == 0)
        return (-1 * (code ^ ((1 << dc_size) - 1)));

    return code;
}

int
get_dc_size_lum(Bitstream * bs)
{
    int     code, i;
    code = BitstreamShowBits(bs, 11);

    for (i = 11; i > 3; i--)
    {
        if (code == 1)
        {
            BitstreamSkip(bs, i);
            return i + 1;
        }
        code >>= 1;
    }

    BitstreamSkip(bs, dc_lum_tab[code].len);
    return dc_lum_tab[code].code;
}

int
get_dc_size_chrom(Bitstream * bs)
{
    uint32  code, i;
    code = BitstreamShowBits(bs, 12);

    for (i = 12; i > 2; i--)
    {
        if (code == 1)
        {
            BitstreamSkip(bs, i);
            return i;
        }
        code >>= 1;
    }

    return 3 - BitstreamGetBits(bs, 2);
}

void
get_intra_block(Bitstream * bs, int16 * block, int direction, int coeff)
{
    const uint16 *scan = scan_tables[direction];
    int     level;
    int     run;
    int     last;

    do
    {
        level = get_coeff(bs, &run, &last, 1, 0);
        if (run == -1)
        {
            // DEBUG("fatal: invalid run");
            break;
        }
        coeff += run;
        block[scan[coeff]] = level;
        if (level < -127 || level > 127)
        {
            // DEBUG1("warning: intra_overflow", level);
        }
        coeff++;
    }
    while (!last);
}

void
get_inter_block(Bitstream * bs, int16 * block)
{
    const uint16 *scan = scan_tables[0];
    int     p;
    int     level;
    int     run;
    int     last;

    p = 0;
    do
    {
        level = get_coeff(bs, &run, &last, 0, 0);
        if (run == -1)
        {
            // DEBUG("fatal: invalid run");
            break;
        }
        p += run;
        block[scan[p]] = level;
        if (level < -127 || level > 127)
        {
            // DEBUG1("warning: inter_overflow", level);
        }
        p++;
    }
    while (!last);
}
