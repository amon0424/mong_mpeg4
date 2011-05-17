#include <stdio.h>
#include <stdlib.h>

volatile int *F_array  = (int *) 0xb0100000;
volatile int *action  = (int *) 0xb0100080;

short block[] = {
    1036,    19,     5,  -147,   127,    24,    85,   -61,
	1037,    20,     6,  -148,   128,    25,    86,   -62
};

int
main(int argc, char **argv)
{
	int result;
	memcpy((void *) F_array, (void *) block, sizeof(short)<<4);

	*action=1;
	while(*action);

	result = F_array[0];
	block[0] = (short)(result >> 16);
	block[1] = (short)(result);

	result = F_array[1];
	block[2] = (short)(result >> 16);
	block[3] = (short)(result);

	printf("%d,%d,%d,%d\n", block[0], block[1], block[2], block[3]);
}