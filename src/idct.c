#include <string.h>

static int c0 = 1448; /* 2048 * 0.7071068 */
static int c1 = 1004; /* 2048 * 0.4903926 */
static int c2 =  946; /* 2048 * 0.4619398 */
static int c3 =  851; /* 2048 * 0.4157348 */
static int c4 =  724; /* 2048 * 0.3535534 */
static int c5 =  569; /* 2048 * 0.2777851 */
static int c6 =  392; /* 2048 * 0.1913417 */
static int c7 =  200; /* 2048 * 0.0975452 */

void
idct_1d(short *output, short *input)
{
    short tmp[8];
    int j1, i, j;
    int yy0, yy1, yy2, yy3, yy5, yy6;
    int e, f, g, h;

    for (i = 0; i < 8; i++)
    {
        memcpy(tmp, input + (i<<3), 8*sizeof(short));
        e      = tmp[1] * c7 - tmp[7] * c1;
        h      = tmp[7] * c7 + tmp[1] * c1;
        f      = tmp[5] * c3 - tmp[3] * c5;
        g      = tmp[3] * c3 + tmp[5] * c5;
        yy0    = (tmp[0] + tmp[4]) * c4;
        yy1    = (tmp[0] - tmp[4]) * c4;
        yy2    = tmp[2] * c6 - tmp[6] * c2;
        yy3    = tmp[6] * c6 + tmp[2] * c2;
        tmp[4] = (e + f + 1024)>>11;
        yy5    = (e - f + 1024)>>11;
        yy6    = (h - g + 1024)>>11;
        tmp[7] = (h + g + 1024)>>11;

        tmp[5] = ((yy6 - yy5) * c0)>>11;
        tmp[6] = ((yy6 + yy5) * c0)>>11;
        tmp[0] = (yy0 + yy3 + 1024)>>11;
        tmp[1] = (yy1 + yy2 + 1024)>>11;
        tmp[2] = (yy1 - yy2 + 1024)>>11;
        tmp[3] = (yy0 - yy3 + 1024)>>11;

        for (j = 0; j < 4; j++)
        {
            j1 = 7 - j;
            output[(j<<3)+i]  = tmp[j] + tmp[j1];
            output[(j1<<3)+i] = tmp[j] - tmp[j1];
        }
    }
}

void
idct(short *block)
{
    short idx, v;
    short tbuf[64];

    /* Horizontal */
    idct_1d(tbuf, block);

    /* Vertical */
    idct_1d(block, tbuf);

    for (idx = 0; idx < 64; idx++)
    {
        v = block[idx];
        block[idx] = (v < -256)? -256 : ((v > 255)? 255 : v);
	}
}
