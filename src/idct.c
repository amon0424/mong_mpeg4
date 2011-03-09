#include <string.h>
#include <math.h>

static double c0, c1, c2, c3, c4, c5, c6, c7;

static double c0 = 0.7071068;
static double c1 = 0.4903926;
static double c2 = 0.4619398;
static double c3 = 0.4157348;
static double c4 = 0.3535534;
static double c5 = 0.2777851;
static double c6 = 0.1913417;
static double c7 = 0.0975452;

void
idct(short *block)
{
    short  j1, i, j;
    double tmp[8];
    double yy0, yy1, yy2, yy3, yy5, yy6;
    double e, f, g, h, coeff[8][8];
    short  v;

    for (i = 0; i < 8; i++)
    {
        for (j = 0; j < 8; j++)
        {
            coeff[i][j] = (double) block[i * 8 + j];
        }
    }

    /* Horizontal */
    /* Descan coefficients first */
    for (i = 0; i < 8; i++)
    {
        for (j = 0; j < 8; j++)
        {
            tmp[j] = coeff[i][j];
        }
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
        tmp[5] = (yy6 - yy5) * c0;
        tmp[6] = (yy6 + yy5) * c0;
        tmp[0] = yy0 + yy3;
        tmp[1] = yy1 + yy2;
        tmp[2] = yy1 - yy2;
        tmp[3] = yy0 - yy3;
        for (j = 0; j < 4; j++)
        {
            j1 = 7 - j;
            block[(i<<3)+j] = tmp[j] + tmp[j1];
            block[(i<<3)+j1] = tmp[j] - tmp[j1];
        }
    }

    /* Vertical */

    for (i = 0; i < 8; i++)
    {
        for (j = 0; j < 8; j++)
        {
            tmp[j] = block[(j<<3)+i];
        }
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
        tmp[5] = (yy6 - yy5) * c0;
        tmp[6] = (yy6 + yy5) * c0;
        tmp[0] = yy0 + yy3;
        tmp[1] = yy1 + yy2;
        tmp[2] = yy1 - yy2;
        tmp[3] = yy0 - yy3;
        for (j = 0; j < 4; j++)
        {
            j1 = 7 - j;
            block[(j<<3)+i] = tmp[j] + tmp[j1];
            block[(j1<<3)+i] = tmp[j] - tmp[j1];
        }
    }

    for (i = 0; i < 64; i++)
    {
        v = (short) floor(block[i] + 0.5);
        block[i] = (v < -256) ? -256 : ((v > 255) ? 255 : v);
	}
}
