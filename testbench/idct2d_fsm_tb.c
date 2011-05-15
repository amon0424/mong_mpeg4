volatile int *action  = (int *) 0xb0100000;

int
main(int argc, char **argv)
{
	*action=1;
	while(*action);
}