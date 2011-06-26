#include <stdio.h>
#include <stdlib.h>
#include <time.h>

volatile long *F_array  = (int *) 0xb0100000;
volatile int *action  = (int *) 0xb0100080;

int
main(int argc, char **argv)
{
	
	int i,j;
	volatile long *F;
	srand(time(NULL));


	for(i=0; i<10000; i++)
	{
		F = F_array;
		for(j=0;j<32;j++)
		{
			unsigned long write = (unsigned long)rand();
			*(F) = write;
			unsigned long read = *(F);

			if(read != write)
			{
				printf("%d,%d: write %#x read %#x\n", i,j,write, read);
				
				printf("second read: ");
				read = *(F);
				if(read != write)
				{
					printf("failed %#x\n", read);
					
					printf("third read: ");
					read = *(F);
					if(read != write)
					{
						printf("failed %#x\n", read);

						printf("rewrite: ");
						*(F) = write;
						read = *(F);
						if(read != write)
						{
							printf("failed %#x\n", read);
						}
						else
							printf("success. \n");
					}
					else
						printf("success. \n");
				}
				else
					printf("success. \n");
			}
			F++;
		}
	}
}