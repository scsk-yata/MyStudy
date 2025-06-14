#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define PI acos(-1)

double _randU(void)
{
	return ((double)rand() / (double)RAND_MAX);
}
double _randN(void)
{
	double s, r, t;
	s = _randU();
	if (s == 0.0)
		s = 0.000000001;
	r = sqrt(-2.0 * log(s));
	t = 2.0 * PI * _randU();
	return (r * sin(t));
}
double _rayl(void)
{
	return sqrt(pow(_randN(), 2.0) + pow(_randN(), 2.0)) * sqrt(0.5);
}
int main(void)
{
	unsigned int i;
	FILE *fp;
	fp = fopen("check_rayl_result.txt", "w");
	for (i = 0; i < 100000; i++)
		fprintf(fp, "%f\n", _rayl());
	return 0;
}