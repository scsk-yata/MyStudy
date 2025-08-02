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
void _randData(unsigned int *d, unsigned int length)
{
	unsigned int i;
	double x;
	for (i = 0; i < length; i++)
	{
		x = _randU();
		if (x >= 0.5)
			*(d + i) = 1.0;
		else
			*(d + i) = 0.0;
	}
}
void _awgn(COMPLEX *n, unsigned int length, double Pn)
{
	unsigned int i;
	for (i = 0; i < length; i++)
	{
		(n + i)->I = _randN() * sqrt(Pn / 2);
		(n + i)->Q = _randN() * sqrt(Pn / 2);
	}
}
double _SNRdB2noisePower(double c_dB)
{
	return pow(10, (-1) * c_dB / 10);
}
void _bpskMod(COMPLEX *s, unsigned int *data, unsigned int length)
{
	unsigned int i;
	for (i = 0; i < length; i++)
		(s + i)->I = (*(data + i) - 0.5) * 2.0;
}
void _vectorSum(COMPLEX *a, COMPLEX *b, COMPLEX *c,
				unsigned int length)
{
	unsigned int i;
	for (i = 0; i < length; i++)
	{
		(a + i)->I = (b + i)->I + (c + i)->I;
		(a + i)->Q = (b + i)->Q + (c + i)->Q;
	}
}
void _bpskDem(unsigned int *rData, COMPLEX *rs, unsigned int length)
{
	unsigned int i;
	for (i = 0; i < length; i++)
	{
		if ((rs + i)->I > 0)
			*(rData + i) = 1;
		else
			*(rData + i) = 0;
	}
}
double _BER(unsigned int *data, unsigned int *rData,
			unsigned int length)
{
	unsigned int i, sum = 0;
	double BER;
	for (i = 0; i < length; i++)
		sum += abs(*(data + i) - *(rData + i));
	BER = (double)sum / length;
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
	unsigned int txData[L], rxData[L], i;
	COMPLEX txSymbol[L], noise[L], rxSymbol[L];
	double BER[SNR_STEP], SNRdB[SNR_STEP];
	for (i = 0; i < SNR_STEP; i++)
		SNRdB[i] = (double)i;
	for (i = 0; i < SNR_STEP; i++)
	{
		srand(time(NULL));

		// ランダムデータの作成
		_randData(txData, L);

		// BPSK変調
		_bpskMod(txSymbol, txData, L);

		// AWGNの発生
		_awgn(noise, L, _SNRdB2noisePower(SNRdB[i]));

		// AWNoiseと受信信号の加算
		_vectorSum(rxSymbol, txSymbol, noise, L);

		// BPSK復調
		_bpskDem(rxData, rxSymbol, L);

		// BERの計算
		BER[i] = _BER(txData, rxData, L);
	}

	// BERのファイルへの書き出し
	_BERprint(SNR_STEP, SNRdB, BER);
	return 0;
}