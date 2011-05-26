#include <stdio.h>
#include <stdlib.h>

long *F_array  = (int *) 0xb0100000;
volatile int *action  = (int *) 0xb0100080;

short block[] = {-52,78,-193,164,-255,-207,157,171
				,101,-146,-114,-64,228,-70,63,-202
				,75,201,224,-43,232,-148,77,-7
				,-125,-212,24,-153,-231,244,246,242
				,-5,-51,30,-175,-181,-85,37,89
				,198,156,-165,-219,61,156,-126,-98
				,130,36,-115,-81,129,100,144,-195
				,72,221,78,19,-81,-215,164,185
				};

int
main(int argc, char **argv)
{
	int idx, result, row;
	short* blockBase;
	unsigned long* lblockBase;
	volatile int* fBase;
	unsigned long* pBase;

	memcpy((void *) F_array, (void *) block, sizeof(short)<<6);

	*action=1;
	while(*action);

	blockBase = block;
	
	lblockBase = (long*)block;
	pBase = F_array;
	for(row=0;row<8;row++)
	{
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);

		/**(blockBase++) = pBase[0];
		*(blockBase++) = pBase[1];
		*(blockBase++) = pBase[2];
		*(blockBase++) = pBase[3];
		*(blockBase++) = pBase[4];
		*(blockBase++) = pBase[5];
		*(blockBase++) = pBase[6];
		*(blockBase++) = pBase[7];

		pBase+=8;*/
	}

	idx=0;
	printf("Results = [\n");
    for (row = 0; row < 8; row++)
    {
        printf("%5d, %5d, %5d, %5d, %5d, %5d, %5d, %5d\n", block[idx++], block[idx++], block[idx++], block[idx++], block[idx++], block[idx++], block[idx++], block[idx++] );
    }
    printf("]\n");
}
