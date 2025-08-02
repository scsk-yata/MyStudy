#include<stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define PI acos(-1) // 3.1415926535
#define L 100000
#define SNR_STEP 11
#define MSEQ_POL_LEN 4
#define MSEQ_POL_COEFF 1, 0, 0, 1
#define L_MSEQ ((1 << MSEQ_POL_LEN) - 1)
#define N_FADING_CHANNEL_TAP 11

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
	SEQ_SIG ssSig;
	SEQ_SIG spCode;
} TX_SIGNALS;

typedef struct
{
	SEQ_DATA data;
	SEQ_SIG symbol;
	SEQ_SIG ssSig;
	SEQ_SIG noise;
	SEQ_SIG mfOut;
	SEQ_SIG rakeOut;
} RX_SIGNALS;

typedef struct
{
	SEQ_SIG coeff;
	SEQ_SIG output;
} CHANNEL;

void _init_tx(TX_SIGNALS *a)
{ // TX_SIGNALSメンバ初期化
	a->data.len = a->symbol.len = L;
	a->spCode.len = L_MSEQ;
	a->ssSig.len = L * L_MSEQ;
}

void _init_rx(RX_SIGNALS *a)
{ // 構造体RX_SIGNALSの初期化
	a->data.len = a->symbol.len = L;
	a->ssSig.len = a->noise.len = L * L_MSEQ + (N_FADING_CHANNEL_TAP - 1);
	a->mfOut.len = a->ssSig.len + (L_MSEQ - 1);
	a->rakeOut.len = a->mfOut.len + (N_FADING_CHANNEL_TAP - 1);
}

void _init_ch(CHANNEL *a)
{ // CHANNELの初期化
	a->coeff.len = N_FADING_CHANNEL_TAP;
	a->output.len = L * L_MSEQ + (N_FADING_CHANNEL_TAP - 1);
}

void _memAlloc_tx(TX_SIGNALS *a)
{ // 構造体TX_SIGNALSのメモリ割当て
	a->data.dat = (unsigned short int *)calloc(a->data.len, sizeof(unsigned short int));
	a->symbol.sig = (COMPLEX *)calloc(a->symbol.len, sizeof(COMPLEX));
	a->spCode.sig = (COMPLEX *)calloc(a->spCode.len, sizeof(COMPLEX));
	a->ssSig.sig = (COMPLEX *)calloc(a->ssSig.len, sizeof(COMPLEX));
	if (a->data.dat == NULL || a->symbol.sig == NULL ||
		a->spCode.sig == NULL || a->ssSig.sig == NULL)
	{
		printf("Error: _memAlloc_tx()，メモリを確保できません．\n");
		exit(1);
	}
}

void _memAlloc_rx(RX_SIGNALS *a)
{ // 構造体RX_SIGNALSのメモリ割当て
	a->data.dat = (unsigned short int *)calloc(a->data.len, sizeof(unsigned short int));
	a->symbol.sig = (COMPLEX *)calloc(a->symbol.len, sizeof(COMPLEX));
	a->noise.sig = (COMPLEX *)calloc(a->noise.len, sizeof(COMPLEX));
	a->ssSig.sig = (COMPLEX *)calloc(a->ssSig.len, sizeof(COMPLEX));
	a->mfOut.sig = (COMPLEX *)calloc(a->mfOut.len, sizeof(COMPLEX));
	a->rakeOut.sig = (COMPLEX *)calloc(a->rakeOut.len, sizeof(COMPLEX));
	if (a->data.dat == NULL || a->symbol.sig == NULL ||
		a->noise.sig == NULL || a->ssSig.sig == NULL ||
		a->mfOut.sig == NULL || a->rakeOut.sig == NULL)
	{
		printf("Error: _memAlloc_rx()，メモリを確保できません．\n");
		exit(1);
	}
}

void _memAlloc_ch(CHANNEL *a)
{ // 構造体CHANNELのメモリ割当て
	a->output.sig = (COMPLEX *)calloc(a->output.len, sizeof(COMPLEX));
	a->coeff.sig = (COMPLEX *)calloc(a->coeff.len, sizeof(COMPLEX));
	if (a->output.sig == NULL || a->coeff.sig == NULL)
	{
		printf("Error: _memAlloc_ch()，メモリを確保できません．\n");
		exit(1);
	}
}

void _memFree_tx(TX_SIGNALS *a)
{ // 構造体TX_SIGNALSのメモリ解放
	free(a->data.dat);
	free(a->symbol.sig);
	free(a->spCode.sig);
	free(a->ssSig.sig);
}

void _memFree_rx(RX_SIGNALS *a)
{ // 構造体RX_SIGNALSのメモリ解放
	free(a->data.dat);
	free(a->symbol.sig);
	free(a->noise.sig);
	free(a->ssSig.sig);
	free(a->mfOut.sig);
	free(a->rakeOut.sig);
}

void _memFree_ch(CHANNEL *a)
{ // 構造体CHANNELのメモリ解放
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

double _snr(SEQ_SIG x, SEQ_SIG r)
{ // 相関係数によるSN比の計算
	COMPLEX row, xr;
	double absRow2, xx, rr;
	xr = _cCorr(x, r, 1);
	xx = _cCorr(x, x, 1).I;
	rr = _cCorr(r, r, 1).I;
	row.I = xr.I / sqrt(xx) / sqrt(rr);
	row.Q = xr.Q / sqrt(xx) / sqrt(rr);
	absRow2 = pow(_cAbs(row), 2.0);
	return absRow2 / (1 - absRow2);
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

void _mf(SEQ_SIG fltOut, SEQ_SIG fltIn, SEQ_SIG w)
{
	SEQ_SIG w_mf;
	unsigned int i;
	if (fltOut.len != (fltIn.len + w.len - 1))
	{
		printf("Error: _mf(), チャネル入力と出力の長さが不整合\n");
		printf("※（チャネル出力の長さ）＝（チャネル入力の長さ）"
			   "＋（フィルタのタップ数-1）となっていなくてはいけません．\n");
		exit(1);
	}
	w_mf.len = w.len;
	w_mf.sig = (COMPLEX *)malloc(sizeof(COMPLEX) * w_mf.len);
	if (w_mf.sig == NULL)
	{
		printf("Error:_mf()，メモリを確保できません．\n");
		exit(1);
	}
	else
	{
		for (i = 0; i < w.len; i++)
			*(w_mf.sig + i) = *(w.sig + (w.len - 1) - i);
		_tvf(fltOut, fltIn, w_mf, 1);
		free(w_mf.sig);
	}
}
void _fadingChCoeff(CHANNEL ch)
{
	unsigned int i, delay[] = {0, 10}, N_DELAY = 2;
	double amp[] = {1.0, 1.0}, phase[] = {0.0, 1.57};
	for (i = 0; i < N_DELAY; i++)
		*(ch.coeff.sig + delay[i]) = _euler(amp[i], phase[i]);
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
// 効率化した _ss()
void _ss(SEQ_SIG ssSig, SEQ_SIG symbol, SEQ_SIG spCode)
{
	unsigned int k, m, cnt = 0;
	for (k = 0; k < symbol.len; k++)
	{
		for (m = 0; m < spCode.len; m++)
		{
			*(ssSig.sig + cnt) = _cPro(*(spCode.sig + m), *(symbol.sig + k));
			cnt++;
		}
	}
}

/*
void _ss(SEQ_SIG ssSig, SEQ_SIG symbol, SEQ_SIG spCode){
	unsigned int k,cnt;
	SEQ_SIG fltInExtnd;
	fltInExtnd.len = (symbol.len -1) * spCode.len +1;
	fltInExtnd.sig = (COMPLEX *)calloc
			(fltInExtnd.len, sizeof(COMPLEX));
	if(fltInExtnd.sig==NULL){
		printf("Error:_ss()，メモリを確保できません．\n");
		exit(1);
	}
	else{
		cnt = 0;
		for(k=0;k<symbol.len;k++){
			*(fltInExtnd.sig+cnt) = *(symbol.sig+k);
			cnt += spCode.len;
		}
		_tvf(ssSig, fltInExtnd, spCode, 0);
		free(fltInExtnd.sig);
	}
}
*/

int main(void)
{
	TX_SIGNALS tx;
	RX_SIGNALS rx;
	CHANNEL ch;
	double BER[SNR_STEP], SNRdB[SNR_STEP];
	unsigned int i, m, head;
	_init_tx(&tx);
	_init_rx(&rx);
	_init_ch(&ch);
	_memAlloc_tx(&tx);
	_memAlloc_rx(&rx);
	_memAlloc_ch(&ch);
	_mseqGen(tx.spCode);
	for (i = 0; i < SNR_STEP; i++)
		SNRdB[i] = (double)i;
	for (i = 0; i < SNR_STEP; i++)
	{
		srand(time(NULL));
		_randData(tx.data);
		_bpskMod(tx.symbol, tx.data);
		_ss(tx.ssSig, tx.symbol, tx.spCode);
		_fadingCh(ch, tx.ssSig);
		_awgn(rx.noise, _SNRdB2noisePower(SNRdB[i]) * (double)tx.spCode.len);
		_vectorSum(rx.ssSig, ch.output, rx.noise);
		_mf(rx.mfOut, rx.ssSig, tx.spCode);
		_mf(rx.rakeOut, rx.mfOut, ch.coeff);

		head = (tx.spCode.len - 1) + (ch.coeff.len - 1);
		for (m = 0; m < rx.symbol.len; m++)
			*(rx.symbol.sig + m) = *(rx.rakeOut.sig + head + tx.spCode.len * m);
		_bpskDem(rx.data, rx.symbol);
		printf("**１波あたりSN比設定=%2.2f[dB], "
			   "RAKE合成後の SNR = %2.2f[dB]\n",
			   SNRdB[i], log10(_snr(rx.symbol, tx.symbol)) * 10);
		BER[i] = _BER(tx.data, rx.data);
	}
	_BERprint(SNR_STEP, SNRdB, BER);
	_memFree_tx(&tx);
	_memFree_rx(&rx);
	_memFree_ch(&ch);
	return 0;
}