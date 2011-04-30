#include <stdio.h>
#include <string.h>
// 80 pixels 0xb0000000 ~ 0xb0000140

volatile int *pixels_base = (int *) 0xb0000000;
volatile int *reg_a = (int *) 0xb0000000;
volatile int *reg_b = (int *) 0xb0000004;
volatile int *reg_c = (int *) 0xb0000008;
volatile int *reg_d = (int *) 0xb000000c;
volatile int *reg_r = (int *) 0xb0000140;
volatile int *reg_mode = (int *) 0xb0000144;
volatile int *mcop1 = (int *) 0xb0000148;
volatile int *mcop2 = (int *) 0xb000014c;

int
main(int argc, char **argv)
{
	int i;
	int result1, result2, result3, result4;

 //   *reg_a = 17;
 //   *reg_b = 5;
 //   *reg_c = 9;
 //   *reg_d = 12;
    *reg_r = 1;

	*(pixels_base) = 17;
	*(pixels_base+1) = 5;
	*(pixels_base+2) = 9;
	*(pixels_base+3) = 12;
	*(pixels_base+4) = 14;
	*(pixels_base+5) = 18;
	
	
	*reg_mode = 0;
	result1 = *(pixels_base);
	result2 = *(pixels_base+1);

	//printf("2-point interpolation of pixel 1= %d\n", *(pixels_base));
	//printf("2-point interpolation of pixel 2= %d\n", *(pixels_base+1));
	
	*reg_mode = 1;
	result3 = *(pixels_base);
	result4 = *(pixels_base+1);

	//printf("4-point interpolation of pixel 1= %d\n", *(pixels_base));
	//printf("4-point interpolation of pixel 2= %d\n", *(pixels_base)+1);
	printf("%d %d %d %d\n", result1, result2, result3, result4);

    //printf("\n");
    //printf("A = %d\n", *reg_a);
    //printf("B = %d\n", *reg_b);
    //printf("C = %d\n", *reg_c);
    //printf("D = %d\n", *reg_d);
    //printf("R = %d\n", *reg_r);

    //printf("\n");
    //printf("2-point interpolation = %d\n", *mcop1);
    //printf("4-point interpolation = %d\n", *mcop2);
    return 0;
}
