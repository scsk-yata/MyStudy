#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#define PI acos(-1) // 3.1415926535
#define L 10000		// 送信データビット数
#define SNR_STEP 10
typedef struct
{
	double I;
	double Q;
} COMPLEX;

typedef struct
{
	COMPLEX *sig;
	unsigned int len;
} SEQ_SIG;

typedef struct
{
	unsigned short int *dat;
	unsigned int len;
} SEQ_DATA;

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

void _randData(SEQ_DATA d)
{
	unsigned int i;
	double x;
	for (i = 0; i < d.len; i++)
	{
		x = _randU();
		if (x >= 0.5)
			*(d.dat + i) = 1.0;
		else
			*(d.dat + i) = 0.0;
	}
}
void _bpskMod(SEQ_SIG s, SEQ_DATA data)
{
	unsigned int i;
	if (s.len != data.len)
	{
		printf("Error: _bpskMod, 長さが一致しません．\n");
		exit(1);
	}
	else
	{
		for (i = 0; i < s.len; i++)
			(s.sig + i)->I = (*(data.dat + i) - 0.5) * 2.0;
	}
}
void _awgn(SEQ_SIG n, double Pn)
{
	double r, t;
	unsigned int i;

	for (i = 0; i < n.len; i++)
	{
		(n.sig + i)->I = _randN() * sqrt(Pn / 2);
		(n.sig + i)->Q = _randN() * sqrt(Pn / 2);
	}
}
double _SNRdB2noisePower(double c_dB)
{
	return pow(10, (-1) * c_dB / 10);
}

void _vectorSum(SEQ_SIG a, SEQ_SIG b, SEQ_SIG c)
{
	unsigned int i;
	if (a.len != b.len || b.len != c.len)
	{
		printf("Error: _vectorSum, 長さが一致しません．\n");
		exit(1);
	}
	else
	{
		for (i = 0; i < a.len; i++)
		{
			(a.sig + i)->I = (b.sig + i)->I + (c.sig + i)->I;
			(a.sig + i)->Q = (b.sig + i)->Q + (c.sig + i)->Q;
		}
	}
}
void _bpskDem(SEQ_DATA rData, SEQ_SIG rs)
{
	unsigned int i;
	for (i = 0; i < rs.len; i++)
	{
		if ((rs.sig + i)->I > 0)
			*(rData.dat + i) = 1;
		else
			*(rData.dat + i) = 0;
	}
}
double _BER(SEQ_DATA data, SEQ_DATA rData)
{
	unsigned int i, sum = 0;
	double BER;
	if (data.len != rData.len)
	{
		printf("Error: _BER() 長さが一致しません．\n");
		exit(1);
	}
	else
	{
		for (i = 0; i < data.len; i++)
			sum += abs(*(data.dat + i) - *(rData.dat + i));
		BER = (double)sum / data.len;
	}
	return (BER);
}
void _BERprint(unsigned int snr_step, double *SNRdB, double *BER)
{
	unsigned int i;
	FILE *fp;
	if ((fp = fopen("BER.txt", "w")) == NULL)
	{
		printf("Error:ファイルを開けません．\n");
		exit(1);
	}
	else
	{
		for (i = 0; i < snr_step; i++)
		{
			printf("%f [dB] BER = %f\n", *(SNRdB + i), *(BER + i));
			fprintf(fp, "%f %f\n", *(SNRdB + i), *(BER + i));
		}
		fclose(fp);
	}
}

int main(void)
{
	SEQ_DATA txData, rxData;
	SEQ_SIG txSymbol, rxSymbol, noise;
	double BER[SNR_STEP], SNRdB[SNR_STEP];
	unsigned int i;
	txData.len = rxData.len = txSymbol.len = rxSymbol.len = noise.len = L;
	txData.dat = (unsigned short int *)malloc(sizeof(unsigned short int) * L);
	rxData.dat = (unsigned short int *)malloc(sizeof(unsigned short int) * L);
	txSymbol.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * L);
	rxSymbol.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * L);
	noise.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * L);

	// for(i=0;i<SNR_STEP;i++) SNRdB[i] = (double)i;
	for (i = 0; i < SNR_STEP; i++)
	{
		SNRdB[i] = (double)i;
		srand(time(NULL));
		_randData(txData);
		_bpskMod(txSymbol, txData);
		_awgn(noise, _SNRdB2noisePower(SNRdB[i]));
		_vectorSum(rxSymbol, txSymbol, noise);
		_bpskDem(rxData, rxSymbol);
		BER[i] = _BER(txData, rxData);
	}
	_BERprint(SNR_STEP, SNRdB, BER);
	free(txData.dat);
	free(rxData.dat);
	free(txSymbol.sig);
	free(txSymbol.sig);
	free(noise.sig);
	return 0;
}