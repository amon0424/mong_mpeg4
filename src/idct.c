#include <string.h>
#include <math.h>
#define SHIFT 11
#define MULTIPLIER 2048
#define HALF_MULTIPLIER 1024
static int c0, c1, c2, c3, c4, c5, c6, c7;

static int c0 = 0.7071068 * MULTIPLIER;
static int c1 = 0.4903926 * MULTIPLIER;
static int c2 = 0.4619398 * MULTIPLIER;
static int c3 = 0.4157348 * MULTIPLIER;
static int c4 = 0.3535534 * MULTIPLIER;
static int c5 = 0.2777851 * MULTIPLIER;
static int c6 = 0.1913417 * MULTIPLIER;
static int c7 = 0.0975452 * MULTIPLIER;

void
idct(short *block_s)
{
    short  j1, i, j;
	int tmp[8];

    int yy0, yy1, yy2, yy3, yy5, yy6;
    int e, f, g, h, coeff[8][8];
    int v;
	int block[64];

	int rowIdx = 0;
    for (i = 0; i < 8; i++)
    {
		coeff[i][0] = block[rowIdx] = block_s[rowIdx]; 
		coeff[i][1] = block[rowIdx+1] = block_s[rowIdx+1];
		coeff[i][2] = block[rowIdx+2] = block_s[rowIdx+2];
		coeff[i][3] = block[rowIdx+3] = block_s[rowIdx+3];
		coeff[i][4] = block[rowIdx+4] = block_s[rowIdx+4];
		coeff[i][5] = block[rowIdx+5] = block_s[rowIdx+5];
		coeff[i][6] = block[rowIdx+6] = block_s[rowIdx+6];
		coeff[i][7] = block[rowIdx+7] = block_s[rowIdx+7];
		rowIdx+=8;
    }

    /* Horizontal */
    /* Descan coefficients first */
    for (i = 0; i < 8; i++)
    {
		tmp[0] = coeff[i][0];
		tmp[1] = coeff[i][1];
		tmp[2] = coeff[i][2];
		tmp[3] = coeff[i][3];
		tmp[4] = coeff[i][4];
		tmp[5] = coeff[i][5];
		tmp[6] = coeff[i][6];
		tmp[7] = coeff[i][7];

        e = tmp[1] * c7 - tmp[7] * c1;
        h = tmp[7] * c7 + tmp[1] * c1;
        f = tmp[5] * c3 - tmp[3] * c5;
        g = tmp[3] * c3 + tmp[5] * c5;
        yy0 = (tmp[0] + tmp[4]) * c4;
        yy1 = (tmp[0] - tmp[4]) * c4;
        yy2 = tmp[2] * c6 - tmp[6] * c2;
        yy3 = tmp[6] * c6 + tmp[2] * c2;
        tmp[4] = e + f;
        yy5 = e - f;
        yy6 = h - g;
        tmp[7] = h + g;
        tmp[5] = ((yy6 - yy5) * c0) >> SHIFT;
        tmp[6] = ((yy6 + yy5) * c0) >> SHIFT;
        tmp[0] = yy0 + yy3;
        tmp[1] = yy1 + yy2;
        tmp[2] = yy1 - yy2;
        tmp[3] = yy0 - yy3;
        for (j = 0; j < 4; j++)
        {
            j1 = 7 - j;
            block[(i<<3)+j] = (tmp[j] + tmp[j1]) >> SHIFT;
            block[(i<<3)+j1] = (tmp[j] - tmp[j1]) >> SHIFT;
        }
    }

    /* Vertical */

    for (i = 0; i < 8; i++)
    {
		tmp[0] = block[i];
		tmp[1] = block[8+i];
		tmp[2] = block[16+i];
		tmp[3] = block[24+i];
		tmp[4] = block[32+i];
		tmp[5] = block[40+i];
		tmp[6] = block[48+i];
		tmp[7] = block[56+i];

        e = tmp[1] * c7 - tmp[7] * c1;
        h = tmp[7] * c7 + tmp[1] * c1;
        f = tmp[5] * c3 - tmp[3] * c5;
        g = tmp[3] * c3 + tmp[5] * c5;
        yy0 = (tmp[0] + tmp[4]) * c4;
        yy1 = (tmp[0] - tmp[4]) * c4;
        yy2 = tmp[2] * c6 - tmp[6] * c2;
        yy3 = tmp[6] * c6 + tmp[2] * c2;
        tmp[4] = e + f;
        yy5 = e - f;
        yy6 = h - g;
        tmp[7] = h + g;
        tmp[5] = ((yy6 - yy5) * c0) >> SHIFT;
        tmp[6] = ((yy6 + yy5) * c0) >> SHIFT;
        tmp[0] = yy0 + yy3;
        tmp[1] = yy1 + yy2;
        tmp[2] = yy1 - yy2;
        tmp[3] = yy0 - yy3;
        for (j = 0; j < 4; j++)
        {
            j1 = 7 - j;
            block[(j<<3)+i] = (tmp[j] + tmp[j1]);
            block[(j1<<3)+i] = (tmp[j] - tmp[j1]);
        }
    }

    for (i = 0; i < 64; i++)
    {
		v = (block[i] + HALF_MULTIPLIER) >> SHIFT;
		block_s[i] = (v < -256) ? -256 : ((v > 255) ? 255 : v);
	}
}
