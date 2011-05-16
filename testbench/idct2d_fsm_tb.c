volatile int *F_array  = (int *) 0xb0100000;
volatile int *action  = (int *) 0xb0100080;

int
main(int argc, char **argv)
{
	short farray[8] = { 1,2,3,4,5,6,7,8 };

	//F_array[0] = *((long*)(farray[0]));
	//F_array[1] = *((long*)(farray[2]));
	//F_array[2] = *((long*)(farray[4]));
	//F_array[3] = *((long*)(farray[6]));
	F_array[0] = 0x20001;
	*action=1;
	while(*action);
}