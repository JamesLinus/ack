/* $Header $ */

_randomi()
{
	int i;
	double f;
	_setchan(-1);
	printf("Random number seed (-32768 to 32767) ? ");
	_readint(&i);
	f=i;
	_setrand(f);
}

_setrand(f)
double f;
{
	int i;
	i=f;
	srand(i);
}
double _rnd(d) double d;
{
	double f; f= (int) rand();
	return(f/32767.0);
}
