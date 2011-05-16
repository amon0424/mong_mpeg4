#include <stdio.h>
#include <stdlib.h>

volatile int *F_array  = (int *) 0xb0100000;
volatile int *action  = (int *) 0xb0100080;

short block[] = {
    1036,    19,     5,  -147,   127,    24,    85,   -61
};

int
main(int argc, char **argv)
{
	memcpy((void *) F_array, (void *) block, sizeof(short)<<3);

	*action=1;
	while(*action);

	*((long*)(block[0])) = F_array[0];
	*((long*)(block[2])) = F_array[1];
	*((long*)(block[4])) = F_array[2];
	*((long*)(block[6])) = F_array[3];
	printf("%d,%d,%d,%d", block[0], block[1], block[2], block[3]);
}