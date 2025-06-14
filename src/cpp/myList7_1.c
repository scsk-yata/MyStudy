#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define PI acos(-1) // 3.1415926535
#define N_FFT 8
#define N_OFDM_SYM 2000 // OFDMシンボル数
#define L_GI 4
#define L_OFDM_SYM (N_FFT + L_GI) // OFDMの1シンボルの長さ[sample]
#define L N_FFT *N_OFDM_SYM
#define MSEQ_POL_LEN 4
#define L_MSEQ ((1 << MSEQ_POL_LEN) - 1)
#define MSEQ_POL_COEFF 1, 0, 0, 1
#define N_FADING_CHANNEL_TAP 20
#define N_DELAY 3
#define DELAY 1, 2, 4
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
	SEQ_DATA data;
	SEQ_SIG symbol;
	SEQ_SIG ofdmSmpl; //
	SEQ_SIG pr_sym;
	SEQ_SIG prmbl;
} TX_SIGNALS;

typedef struct
{
	SEQ_DATA data;
	SEQ_SIG symbol;
	SEQ_SIG ofdmSmpl;
	SEQ_SIG pr_sym;
	SEQ_SIG prmbl;
	SEQ_SIG noise;
} RX_SIGNALS;

typedef struct
{
	double tau1;
	double mtgn_dB;
	SEQ_SIG coeff;
	SEQ_SIG output;
	SEQ_SIG estChCoeff;
} CHANNEL;

void _init_tx(TX_SIGNALS *a)
{ // TX_SIGNALSメンバ初期化
	a->data.len = a->symbol.len = L;
	a->prmbl.len = L_MSEQ;
	a->pr_sym.len = L_MSEQ * N_FFT + L;
	a->ofdmSmpl.len = L_OFDM_SYM * (N_OFDM_SYM + a->prmbl.len);
}

void _init_rx(RX_SIGNALS *a)
{ // 構造体RX_SIGNALSの初期化
	a->data.len = a->symbol.len = L;
	a->prmbl.len = L_MSEQ;
	a->pr_sym.len = (L_MSEQ * N_FFT + L);
	a->noise.len = a->ofdmSmpl.len =
		L_OFDM_SYM * (N_OFDM_SYM + L_MSEQ) + (N_FADING_CHANNEL_TAP - 1);
}

void _init_ch(CHANNEL *a)
{ // CHANNELの初期化
	a->coeff.len = N_FADING_CHANNEL_TAP;
	a->estChCoeff.len = N_FFT;
	a->output.len = L_OFDM_SYM * (N_OFDM_SYM + L_MSEQ) + (N_FADING_CHANNEL_TAP - 1);
	a->tau1 = TAU1;
	a->mtgn_dB = MITIGATION_DB;
}

void _memAlloc_tx(TX_SIGNALS *a)
{ // 構造体TX_SIGNALSのメモリ割当て
	a->data.dat = (unsigned short int *)
		calloc(a->data.len,
			   sizeof(unsigned short int));
	a->symbol.sig = (COMPLEX *)
		calloc(a->symbol.len, sizeof(COMPLEX));
	a->prmbl.sig = (COMPLEX *)
		calloc(a->prmbl.len, sizeof(COMPLEX));
	a->pr_sym.sig = (COMPLEX *)
		calloc(a->pr_sym.len,
			   sizeof(COMPLEX));
	a->ofdmSmpl.sig = (COMPLEX *)
		calloc(a->ofdmSmpl.len, sizeof(COMPLEX));
	if (a->data.dat == NULL || a->symbol.sig == NULL || a->prmbl.sig == NULL || a->pr_sym.sig == NULL || a->ofdmSmpl.sig == NULL)
	{
		printf("Error: _memAlloc_tx()，メモリを確保できません．\n");
		exit(1);
	}
}

void _memAlloc_rx(RX_SIGNALS *a)
{ // 構造体RX_SIGNALSのメモリ割当て
	a->data.dat = (unsigned short int *)
		calloc(a->data.len,
			   sizeof(unsigned short int));
	a->symbol.sig = (COMPLEX *)
		calloc(a->symbol.len, sizeof(COMPLEX));
	a->prmbl.sig = (COMPLEX *)
		calloc(a->prmbl.len, sizeof(COMPLEX));
	a->pr_sym.sig = (COMPLEX *)
		calloc(a->pr_sym.len,
			   sizeof(COMPLEX));
	a->ofdmSmpl.sig = (COMPLEX *)
		calloc(a->ofdmSmpl.len,
			   sizeof(COMPLEX));
	a->noise.sig = (COMPLEX *)
		calloc(a->noise.len, sizeof(COMPLEX));
	if (a->data.dat == NULL || a->symbol.sig == NULL || a->prmbl.sig == NULL || a->pr_sym.sig == NULL || a->ofdmSmpl.sig == NULL || a->noise.sig == NULL)
	{
		printf("Error: _memAlloc_rx()，メモリを確保できません．\n");
		exit(1);
	}
}

void _memAlloc_ch(CHANNEL *a)
{ // 構造体CHANNELのメモリ割当て
	a->coeff.sig = (COMPLEX *)
		calloc(a->coeff.len, sizeof(COMPLEX));
	a->estChCoeff.sig = (COMPLEX *)
		calloc(a->estChCoeff.len,
			   sizeof(COMPLEX));
	a->output.sig = (COMPLEX *)
		calloc(a->output.len, sizeof(COMPLEX));
	if (a->coeff.sig == NULL || a->estChCoeff.sig == NULL || a->output.sig == NULL)
	{
		printf("Error: _memAlloc_ch()，メモリを確保できません．\n");
		exit(1);
	}
}

void _memFree_tx(TX_SIGNALS *a)
{ // 構造体TX_SIGNALSのメモリ解放
	free(a->data.dat);
	free(a->symbol.sig);
	free(a->prmbl.sig);
	free(a->pr_sym.sig);
	free(a->ofdmSmpl.sig);
}

void _memFree_rx(RX_SIGNALS *a)
{ // 構造体RX_SIGNALSのメモリ解放
	free(a->data.dat);
	free(a->symbol.sig);
	free(a->prmbl.sig);
	free(a->pr_sym.sig);
	free(a->ofdmSmpl.sig);
	free(a->noise.sig);
}

void _memFree_ch(CHANNEL *a)
{ // 構造体CHANNELのメモリ解放
	free(a->coeff.sig);
	free(a->estChCoeff.sig);
	free(a->output.sig);
}

COMPLEX _cSum(COMPLEX a, COMPLEX b)
{
	COMPLEX c;
	c.I = a.I + b.I;
	c.Q = a.Q + b.Q;
	return c;
}

COMPLEX _cSub(COMPLEX a, COMPLEX b)
{
	COMPLEX c;
	c.I = a.I - b.I;
	c.Q = a.Q - b.Q;
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

int _log2(int x)
{
	int n = 0;
	while ((x >> n) > 1)
		n++;
	return n;
}

void _FFT_bitReversal(int *rev, int n_fft)
{
	int i, k, n, co, flag;
	for (i = 0; i < n_fft; i++)
		rev[i] = 0;
	co = n_fft >> 1;
	for (k = 0; k < _log2(n_fft); k++)
	{
		flag = 0;
		for (i = 0; i < n_fft; i++)
		{
			if (i % co == 0)
				flag = (flag++) % 2;
			rev[i] += (flag - 1) * (1 << k);
		}
		co >>= 1;
	}
}

void _FFT(SEQ_SIG s2, SEQ_SIG FFTin)
{
	int a, B, wnIndx, i, g, G, m, M, k_dan, revSeq[N_FFT],
		N_FFT_2 = N_FFT / 2, log2_N_FFT;
	SEQ_SIG wn_FFT, s;
	wn_FFT.len = N_FFT_2;
	s.len = N_FFT;
	wn_FFT.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * wn_FFT.len);
	s.sig = (COMPLEX *)calloc(s.len, sizeof(COMPLEX));
	if (wn_FFT.sig == NULL || s.sig == NULL)
		printf("Error:_FFT()，メモリを確保できません．\n");
	else
	{
		_FFT_bitReversal(revSeq, N_FFT);
		for (i = 0; i < N_FFT; i++)
			*(s.sig + i) = *(FFTin.sig + revSeq[i]);
		for (i = 0; i < N_FFT_2; i++)
			*(wn_FFT.sig + i) = _euler(1, (-2) * PI / N_FFT * i);
		log2_N_FFT = _log2(N_FFT);
		M = 1;
		G = N_FFT_2;
		// バタフライ演算
		for (k_dan = 0; k_dan < log2_N_FFT; k_dan++)
		{
			a = B = 0;
			for (g = 0; g < G; g++)
			{
				wnIndx = 0;
				for (m = 0; m < M; m++)
				{
					*(s2.sig + a) =
						_cSum(*(s.sig + m + B),
							  _cPro(*(wn_FFT.sig + wnIndx),
									*(s.sig + m + (int)pow(2, (k_dan)) + B)));
					a++;
					wnIndx += G % N_FFT_2;
				}
				wnIndx = 0;
				for (m = 0; m < M; m++)
				{
					*(s2.sig + a) =
						_cSub(*(s.sig + m + B),
							  _cPro(*(wn_FFT.sig + wnIndx),
									*(s.sig + m + (int)pow(2, (k_dan)) + B)));
					a++;
					wnIndx += G % N_FFT_2;
				}
				B += m + (int)pow(2, (k_dan));
			}
			M *= 2;
			G /= 2;
			for (i = 0; i < N_FFT; i++)
				*(s.sig + i) = *(s2.sig + i);
		}
		free(wn_FFT.sig);
		free(s.sig);
	}
}

void _IFFT(SEQ_SIG s2, SEQ_SIG IFFTin)
{
	int a, B, wnIndx, i, g, G, m, M, k_dan, revSeq[N_FFT],
		N_FFT_2 = N_FFT / 2, log2_N_FFT;
	SEQ_SIG wn_FFT, s;
	wn_FFT.len = N_FFT_2;
	s.len = N_FFT;
	wn_FFT.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * wn_FFT.len);
	s.sig = (COMPLEX *)calloc(s.len, sizeof(COMPLEX));
	if (wn_FFT.sig == NULL || s.sig == NULL)
		printf("Error:_IFFT()，メモリを確保できません．\n");
	else
	{
		_FFT_bitReversal(revSeq, N_FFT);
		for (i = 0; i < N_FFT; i++)
			*(s.sig + i) = *(IFFTin.sig + revSeq[i]);
		for (i = 0; i < N_FFT_2; i++)
			*(wn_FFT.sig + i) = _euler(1, 2 * PI / N_FFT * i);
		log2_N_FFT = _log2(N_FFT);
		M = 1;
		G = N_FFT_2;
		// バタフライ演算
		for (k_dan = 0; k_dan < log2_N_FFT; k_dan++)
		{
			a = B = 0;
			for (g = 0; g < G; g++)
			{
				wnIndx = 0;
				for (m = 0; m < M; m++)
				{
					*(s2.sig + a) =
						_cSum(*(s.sig + m + B),
							  _cPro(*(wn_FFT.sig + wnIndx),
									*(s.sig + m + (int)pow(2, (k_dan)) + B)));
					a++;
					wnIndx += G % N_FFT_2;
				}
				wnIndx = 0;
				for (m = 0; m < M; m++)
				{
					*(s2.sig + a) =
						_cSub(*(s.sig + m + B),
							  _cPro(*(wn_FFT.sig + wnIndx),
									*(s.sig + m + (int)pow(2, (k_dan)) + B)));
					a++;
					wnIndx += G % N_FFT_2;
				}
				B += m + (int)pow(2, (k_dan));
			}
			M *= 2;
			G /= 2;
			for (i = 0; i < N_FFT; i++)
				*(s.sig + i) = *(s2.sig + i);
		}
		for (i = 0; i < N_FFT; i++)
		{
			(s2.sig + i)->I /= (double)N_FFT;
			(s2.sig + i)->Q /= (double)N_FFT;
		}
		free(wn_FFT.sig);
		free(s.sig);
	}
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
		printf("Error: _fadingCh(),チャネル入力と出力の長さが"
			   "不整合\n");
		printf("※（チャネル出力の長さ）＝（チャネル入力の長さ）"
			   "＋（フェージングチャネルのタップ数-1）"
			   "となっていなくてはいけません．\n");
		exit(1);
	}
	_fadingChCoeff(ch);
	printf("フェージングを実現するトランスバーサルフィルタの重み係数\n");
	for (i = 0; i < ch.coeff.len; i++)
		printf("%f %f\n", (ch.coeff.sig + i)->I, (ch.coeff.sig + i)->Q);
	_tvf(ch.output, chIn, ch.coeff, 0);
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

void _ofdmTx(SEQ_SIG ofdmSmpl, SEQ_SIG symbol)
{
	unsigned int k, m;
	SEQ_SIG spcOut, IFFTout;
	IFFTout.len = spcOut.len = N_FFT;
	IFFTout.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * IFFTout.len);
	spcOut.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * spcOut.len);
	if (IFFTout.sig == NULL || spcOut.sig == NULL)
	{
		printf("Error:ofdmTx()，メモリを確保できません．\n");
		exit(1);
	}
	else
	{
		for (k = 0; k < (symbol.len / N_FFT); k++)
		{
			// S/P変換
			for (m = 0; m < N_FFT; m++)
				*(spcOut.sig + m) = *(symbol.sig + k * N_FFT + m);
			_IFFT(IFFTout, spcOut);
			// GIの付加
			for (m = 0; m < L_GI; m++)
				*(ofdmSmpl.sig + k * L_OFDM_SYM + m) = *(IFFTout.sig + (N_FFT - L_GI) + m);
			// OFDMサンプル
			for (m = 0; m < N_FFT; m++)
				*(ofdmSmpl.sig + k * L_OFDM_SYM + L_GI + m) = *(IFFTout.sig + m);
		}
		free(IFFTout.sig);
		free(spcOut.sig);
	}
}
void _ofdmRx(SEQ_SIG rxSymbol, SEQ_SIG rs)
{
	unsigned int k, m;
	SEQ_SIG spcOut, FFTout;
	FFTout.len = spcOut.len = N_FFT;
	FFTout.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * FFTout.len);
	spcOut.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * spcOut.len);
	if (FFTout.sig == NULL || spcOut.sig == NULL)
	{
		printf("Error:ofdmRx()，メモリを確保できません．\n");
		exit(1);
	}
	else
	{
		for (k = 0; k < (rs.len / (N_FFT + L_GI)); k++)
		{
			// GI除去
			for (m = 0; m < N_FFT; m++)
				*(spcOut.sig + m) = *(rs.sig + k * L_OFDM_SYM + L_GI + m);
			_FFT(FFTout, spcOut);
			for (m = 0; m < N_FFT; m++)
				*(rxSymbol.sig + k * N_FFT + m) = *(FFTout.sig + m);
		}
		free(FFTout.sig);
		free(spcOut.sig);
	}
}

int main(void)
{
	TX_SIGNALS tx;
	RX_SIGNALS rx;
	CHANNEL ch;
	unsigned int i, k, m;
	_init_tx(&tx);
	_init_rx(&rx);
	_init_ch(&ch);
	_memAlloc_tx(&tx);
	_memAlloc_rx(&rx);
	_memAlloc_ch(&ch);
	_randData(tx.data);
	_bpskMod(tx.symbol, tx.data);
	_mseqGen(tx.prmbl);
	m = 0;
	// プリアンブルを入れる
	for (i = 0; i < tx.prmbl.len; i++)
	{
		for (k = 0; k < N_FFT; k++)
		{
			*(tx.pr_sym.sig) = *(tx.prmbl.sig + i);
			m++;
		}
	}
	// シンボルを入れる
	*(tx.pr_sym.sig + (tx.prmbl.len * N_FFT) + k) = *(tx.symbol.sig + k);
	_ofdmTx(tx.ofdmSmpl, tx.pr_sym);
	_fadingCh(ch, tx.ofdmSmpl);
	_awgn(rx.noise, _SNRdB2noisePower(100000.0) / (double)N_FFT);
	_vectorSum(rx.ofdmSmpl, ch.output, rx.noise);
	_ofdmRx(rx.pr_sym, rx.ofdmSmpl);
	// プリアンブル抽出とチャネル係数の算出
	for (k = 0; k < N_FFT; k++)
	{
		for (m = 0; m < tx.prmbl.len; m++)
			*(rx.prmbl.sig + m) = *(rx.pr_sym.sig + k + N_FFT * m);
		*(ch.estChCoeff.sig + k) = _cCorr(rx.prmbl, tx.prmbl, 0);
	}
	// 位相補正とシンボルの取り出し
	for (k = 0; k < tx.symbol.len; k++)
		*(rx.symbol.sig + k) =
			_cPro(*(rx.pr_sym.sig + tx.prmbl.len * N_FFT + k), _conj(*(ch.estChCoeff.sig + (k % N_FFT))));
	_bpskDem(rx.data, rx.symbol);
	printf("BERは%fです．\n", _BER(tx.data, rx.data));
	_memFree_tx(&tx);
	_memFree_rx(&rx);
	_memFree_ch(&ch);
	return 0;
}