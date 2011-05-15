#include <stdio.h>
#include <stdlib.h>

/* HW accelerator interface */
long *F_array           = (long *) 0xb0100000;
long *p_array           = (long *) 0xb0100010;
volatile long *action   = (long *) 0xb0100020;

/* IDCT kernel */
long idct_HU[] = {
     724,   946,  724,  392,
     724,   392, -724, -946,
     724,  -392, -724,  946,
     724,  -946,  724, -392
};

long idct_HL[] = {
    1004,   851,  569,  200,
    -851,   200, 1004,  569,
     569, -1004,  200,  851,
    -200,   569, -851, 1004
};

#if 0
/* IDCT test pattern */
short my_block[][8] = {
  { 1036,    19,     5,  -147,   127,    24,    85,   -61 },
  {   15,    24,    -5,    63,   -75,    61,    73,   -58 },
  {  -40,   -47,   -30,    42,   -31,    98,    92,    42 },
  {  -32,   -25,   129,   100,     5,    73,  -180,    90 },
  { -131,   -74,    16,     9,   -30,    17,    15,   154 },
  {   -3,    58,   -99,    77,     1,   138,   -61,    11 },
  {    3,   -66,    75,    -4,   -23,   -57,   -79,   -39 },
  {  10,   -18,   118,    46,     4,    41,    90,   -35 }
};
#endif

short block[] = {
    1036,    19,     5,  -147,   127,    24,    85,   -61
};

short  block_hw[64];

void
H_mul_v(long *v4dst, long *m4x4, long *v4src)
{
    int row;

    for (row = 0; row < 4; row++)
    {
        v4dst[row] = m4x4[(row<<2)+0] * v4src[0] +
                     m4x4[(row<<2)+1] * v4src[1] +
                     m4x4[(row<<2)+2] * v4src[2] +
                     m4x4[(row<<2)+3] * v4src[3];
    }
}

void
idct_1d(short *idct, short *coeff)
{
    long v[4], g[8];

    /* compute even-point values */
    v[0] = coeff[0];
    v[1] = coeff[2];
    v[2] = coeff[4];
    v[3] = coeff[6];
    H_mul_v(g, idct_HU, v);

    /* compute odd-point values */
    v[0] = coeff[1];
    v[1] = coeff[3];
    v[2] = coeff[5];
    v[3] = coeff[7];
    H_mul_v(g+4, idct_HL, v);

    /* scale-down and save result */
    idct[0] = (short) ((g[0]+g[4]+1024) >> 11);
    idct[1] = (short) ((g[1]-g[5]+1024) >> 11);
    idct[2] = (short) ((g[2]+g[6]+1024) >> 11);
    idct[3] = (short) ((g[3]-g[7]+1024) >> 11);
    idct[4] = (short) ((g[3]+g[7]+1024) >> 11);
    idct[5] = (short) ((g[2]-g[6]+1024) >> 11);
    idct[6] = (short) ((g[1]+g[5]+1024) >> 11);
    idct[7] = (short) ((g[0]-g[4]+1024) >> 11);
}

int
main(int argc, char *argv[])
{
    int col, jdx;
    short temp[8];

    printf("\nDCT Coefficis = [ ");
    for (col = 0; col < 8; col++)
    {
        printf("%5d ", block[col]);
    }
    printf(" ]\n");

    idct_1d(temp, block);
    printf("IDCT  Results = [ ");
    for (col = 0; col < 8; col++)
    {
        printf("%5d ", temp[col]);
    }
    printf(" ]\n");

    /* compute idct using hardware logic */
    /* row transform */
#if 1
    memcpy((void *) F_array, (void *) block, sizeof(short)<<3);
#else
    for (col = 0; col < 8; col+=2)
    {
        F_array[col>>1] = *((long *) (block+col));
    }
#endif

    printf("HW IDCT Input = [ ");
    for (col = 0; col < 8; col++)
    {
        printf("%5ld ", ((short *) F_array)[col]);
    }
    printf(" ]\n");

    *action = 1;
    while (*action) /* do nothing */;

    for (col = 0; col < 8; col++)
    {
        temp[col] = ((short *) p_array)[col];
    }

    printf("HW IDCT Rests = [ ");
    for (col = 0; col < 8; col++)
    {
        printf("%5d ", temp[col]);
    }
    printf(" ]\n");

    return 0;
}
