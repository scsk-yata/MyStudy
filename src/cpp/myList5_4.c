#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define PI acos(-1)
#define MSEQ_POL_LEN 4
#define MSEQ_POL_COEFF 1, 0, 0, 1
#define L_MSEQ ((1 << MSEQ_POL_LEN) - 1)
#define N_FADING_CHANNEL_TAP 20
#define N_DELAY 4
#define DELAY 0, 4, 8, 15
#define TAU1 15
#define MITIGATION_DB 10

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

typedef struct
{
	SEQ_SIG testSeq;
} TX_SIGNALS;

typedef struct
{
	SEQ_SIG testSeq;
	SEQ_SIG noise;
} RX_SIGNALS;

typedef struct
{
	double tau1;
	double mtgn_dB;
	SEQ_SIG coeff;
	SEQ_SIG output;
} CHANNEL;

void _init_tx(TX_SIGNALS *a)
{
	a->testSeq.len = L_MSEQ;
}
void _init_rx(RX_SIGNALS *a)
{
	a->noise.len = a->testSeq.len = L_MSEQ + (N_FADING_CHANNEL_TAP - 1);
}

void _init_ch(CHANNEL *a)
{
	a->coeff.len = N_FADING_CHANNEL_TAP;
	a->tau1 = TAU1;
	a->mtgn_dB = MITIGATION_DB;
	a->output.len = L_MSEQ + (N_FADING_CHANNEL_TAP - 1);
}

void _memAlloc_tx(TX_SIGNALS *a)
{
	a->testSeq.sig = (COMPLEX *)calloc(a->testSeq.len, sizeof(COMPLEX));
	if (a->testSeq.sig == NULL)
	{
		printf("Error:_memAlloc(),メモリを確保できません．\n");
		exit(1);
	}
}

void _memAlloc_rx(RX_SIGNALS *a)
{
	a->testSeq.sig = (COMPLEX *)calloc(a->testSeq.len, sizeof(COMPLEX));
	a->noise.sig = (COMPLEX *)calloc(a->noise.len, sizeof(COMPLEX));
	if (a->testSeq.sig == NULL || a->noise.sig == NULL)
	{
		printf("Error:_memAlloc(),メモリを確保できません．\n");
		exit(1);
	}
}

void _memAlloc_ch(CHANNEL *a)
{
	a->output.sig = (COMPLEX *)calloc(a->output.len, sizeof(COMPLEX));
	a->coeff.sig = (COMPLEX *)calloc(a->coeff.len, sizeof(COMPLEX));
	if (a->output.sig == NULL || a->coeff.sig == NULL)
	{
		printf("Error:_memAlloc(),メモリを確保できません．\n");
		exit(1);
	}
}

void _memFree_tx(TX_SIGNALS *a) { free(a->testSeq.sig); }
void _memFree_rx(RX_SIGNALS *a)
{
	free(a->testSeq.sig);
	free(a->noise.sig);
}
void _memFree_ch(CHANNEL *a)
{
	free(a->output.sig);
	free(a->coeff.sig);
}

COMPLEX _cSum(COMPLEX a, COMPLEX b)
{
	COMPLEX c;
	c.I = a.I + b.I;
	c.Q = a.Q + b.Q;
	return c;
}

COMPLEX _cPro(COMPLEX a, COMPLEX b)
{
	COMPLEX c;
	c.I = a.I * b.I - a.Q * b.Q;
	c.Q = a.I * b.Q + a.Q * b.I;
	return c;
}

COMPLEX _conj(COMPLEX a)
{
	a.Q = (-1) * a.Q;
	return a;
}

double _cAbs(COMPLEX a)
{
	double abs;
	abs = sqrt(pow(a.I, 2) + pow(a.Q, 2));
	return abs;
}

COMPLEX _euler(double A, double phi)
{
	COMPLEX c;
	c.I = A * cos(phi);
	c.Q = A * sin(phi);
	return c;
}

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

COMPLEX _cCorr(SEQ_SIG s, SEQ_SIG w, unsigned short int conjFlag)
{
	unsigned int i;
	COMPLEX tmp, corr = {0.0, 0.0};
	// conjFlagが1なら，重み係数がconj
	if (s.len != w.len)
	{
		printf("Error: _cCorr, 長さが一致しません．\n");
		exit(1);
	}
	else
	{
		if (conjFlag == 1)
		{
			for (i = 0; i < s.len; i++)
			{
				tmp = _cPro(*(s.sig + i), _conj(*(w.sig + i)));
				corr = _cSum(tmp, corr);
			}
		}
		else
		{
			for (i = 0; i < s.len; i++)
			{
				tmp = _cPro(*(s.sig + i), *(w.sig + i));
				corr = _cSum(tmp, corr);
			}
		}
	}
	return corr;
}

void _tvf(SEQ_SIG fltOut, SEQ_SIG fltIn, SEQ_SIG w, unsigned short int conjFlag)
{
	unsigned int i, k, tapCount;
	SEQ_SIG tap, fltIn_0add;
	if (fltOut.len != fltIn.len + (w.len - 1))
	{
		printf("Error: _tvf(), チャネル入力と出力の長さが不整合\n");
		printf("※（チャネル出力の長さ）＝"
			   "（チャネル入力の長さ）＋（フィルタのタップ数-1）"
			   "となっていなくてはいけません．\n");
		exit(1);
	}
	else
	{
		tap.len = w.len;
		tap.sig = (COMPLEX *)calloc(tap.len, sizeof(COMPLEX));
		fltIn_0add.len = fltIn.len + (w.len - 1) * 2;
		fltIn_0add.sig =
			(COMPLEX *)calloc(fltIn_0add.len, sizeof(COMPLEX));
		if (tap.sig == NULL || fltIn_0add.sig == NULL)
		{
			printf("Error:_tvf()，メモリを確保できません．\n");
			exit(1);
		}
		else
		{
			for (i = 0; i < fltIn.len; i++)
				*(fltIn_0add.sig + (w.len - 1) + i) = *(fltIn.sig + i);
			for (k = 0; k < fltOut.len; k++)
			{
				for (i = 0; i < tap.len; i++)
					*(tap.sig + i) =
						*(fltIn_0add.sig + (tap.len - 1 + k) - i);
				*(fltOut.sig + k) = _cCorr(tap, w, conjFlag);
			}
			free(tap.sig);
			free(fltIn_0add.sig);
		}
	}
}

void _mseqGen(SEQ_SIG mseq)
{ // M系列の生成
	unsigned long int i;
	int k, tmp, tap[MSEQ_POL_LEN] = {0.0},
				mseqPol[] = {MSEQ_POL_COEFF};
	tap[0] = 1;
	for (i = 0; i < mseq.len; i++)
	{
		(mseq.sig + i)->I = (double)tap[MSEQ_POL_LEN - 1];
		tmp = 0;
		for (k = 0; k < MSEQ_POL_LEN; k++)
		{
			tmp += tap[k] * mseqPol[k];
			tmp = tmp % 2;
		}
		for (k = (MSEQ_POL_LEN - 1); k > 0; k--)
			tap[k] = tap[k - 1];
		tap[0] = tmp;
	}
	for (i = 0; i < mseq.len; i++)
	{
		if ((mseq.sig + i)->I == 0.0)
			(mseq.sig + i)->I = -1.0;
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

double _rayl(void)
{
	return sqrt(pow(_randN(), 2.0) + pow(_randN(), 2.0)) * sqrt(0.5);
}

void _fadingChCoeff(CHANNEL ch)
{
	unsigned int i, delay[] = {DELAY};
	double mtgn, delta, p_tau, rayleighAmp, randPhase;
	mtgn = pow(10.0, ch.mtgn_dB / 10.0);
	delta = (-1.0) * ch.tau1 / log(mtgn);
	for (i = 0; i < N_DELAY; i++)
	{
		p_tau = exp((double)delay[i] / delta);
		rayleighAmp = _rayl() * sqrt(p_tau);
		randPhase = _randU() * 2 * PI;
		*(ch.coeff.sig + delay[i]) = _euler(rayleighAmp, randPhase);
	}
}

void _fadingCh(CHANNEL ch, SEQ_SIG chIn)
{
	unsigned int i;
	if (ch.output.len != (chIn.len + N_FADING_CHANNEL_TAP - 1))
	{
		printf("Error: _fadingCh(),チャネル入力と出力の長さが不整合\n");
		printf("※（チャネル出力の長さ）=（チャネル入力の長さ）+（フェージングチャネルのタップ数-1）となっていなくてはいけません．\n");
		exit(1);
	}
	_fadingChCoeff(ch);
	printf("フェージングを実現するトランスバーサルフィルタの重み係数\n");
	for (i = 0; i < ch.coeff.len; i++)
		printf("%f %f\n", (ch.coeff.sig + i)->I, (ch.coeff.sig + i)->Q);
	_tvf(ch.output, chIn, ch.coeff, 0);
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

int main(void)
{
	TX_SIGNALS tx;
	RX_SIGNALS rx;
	CHANNEL ch;
	srand(time(NULL));
	_init_tx(&tx);
	_init_rx(&rx);
	_init_ch(&ch);
	_memAlloc_tx(&tx);
	_memAlloc_rx(&rx);
	_memAlloc_ch(&ch);
	_mseqGen(tx.testSeq);
	_fadingCh(ch, tx.testSeq);
	_awgn(rx.noise, _SNRdB2noisePower(10.0));
	_vectorSum(rx.testSeq, ch.output, rx.noise);
	_memFree_tx(&tx);
	_memFree_rx(&rx);
	_memFree_ch(&ch);
	return 0;
}