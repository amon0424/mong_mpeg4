#include <stdio.h>
#include <stdlib.h>

long *F_array  = (int *) 0xb0100000;
volatile int *action  = (int *) 0xb0100080;
long *F_array_2  = (int *) 0xb0200000;
volatile int *action_2  = (int *) 0xb0200080;

short block1[] = {-52,78,-193,164,-255,-207,157,171
				,101,-146,-114,-64,228,-70,63,-202
				,75,201,224,-43,232,-148,77,-7
				,-125,-212,24,-153,-231,244,246,242
				,-5,-51,30,-175,-181,-85,37,89
				,198,156,-165,-219,61,156,-126,-98
				,130,36,-115,-81,129,100,144,-195
				,72,221,78,19,-81,-215,164,185
				};

short block2[] = {-52,78,-193,164,-255,-207,157,171
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
	int idx;
	int row;
	long* lblockBase;
	long* pBase;
	long* fBase;

	


	// copy block 1
	memcpy((void *) F_array, (void *) block1, sizeof(short)<<6);
	
	// action block1
	*action=1;

	// copy block 2
	memcpy((void *) F_array_2, (void *) block2, sizeof(short)<<6);

	// action block2
	*action_2=1;

	// get block1
	while(*action);
	lblockBase = (long*)block1;
	pBase = F_array;
	for(row=0;row<8;row++)
	{	
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
	}

	// get block2
	while(*action_2);
	lblockBase = (long*)block2;
	pBase = F_array_2;
	for(row=0;row<8;row++)
	{	
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
		*(lblockBase++) = *(pBase++);
	}

	idx=0;
	printf("Results1 = [\n");
    for (row = 0; row < 8; row++)
    {
        printf("%5d, %5d, %5d, %5d, %5d, %5d, %5d, %5d\n", block1[idx++], block1[idx++], block1[idx++], block1[idx++], block1[idx++], block1[idx++], block1[idx++], block1[idx++] );
    }
    printf("]\n");
	idx = 0;
	printf("Results2 = [\n");
    for (row = 0; row < 8; row++)
    {
        printf("%5d, %5d, %5d, %5d, %5d, %5d, %5d, %5d\n", block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++], block2[idx++] );
    }
    printf("]\n");
}
