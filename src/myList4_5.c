#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<time.h>

#define PI acos(-1)//3.1415926535
#define L 10000 //送信データビット数
#define SNR_STEP 10

typedef struct{
	double I;
	double Q;
}COMPLEX;
typedef struct{
	COMPLEX *sig;
	unsigned int len;
}SEQ_SIG;
typedef struct{
	unsigned short int *dat;
	unsigned int len;
}SEQ_DATA;

typedef struct{
	SEQ_DATA data;
	SEQ_SIG symbol;
}TX_SIGNALS;
typedef struct{
	SEQ_DATA data;
	SEQ_SIG symbol;
	SEQ_SIG noise;
}RX_SIGNALS;

void _init_tx(TX_SIGNALS *a){
	a->data.len = L;
	a->symbol.len = L;
}
void _init_rx(RX_SIGNALS *a){
	a->data.len = L;
	a->symbol.len = a->noise.len = L;
}
void _memAlloc_tx(TX_SIGNALS *a){
	a->data.dat = (unsigned short int*)
				malloc(sizeof(unsigned short int)*a->data.len);
	a->symbol.sig = (COMPLEX *)
				malloc(sizeof(COMPLEX)*a->symbol.len);
	if(a->data.dat==NULL||a->symbol.sig==NULL){
		printf("Error: _memAlloc_tx(), メモリを確保できません．\n");
		exit(1);
	}
}
void _memAlloc_rx(RX_SIGNALS *a){
	a->data.dat = (unsigned short int*)
				malloc(sizeof(unsigned short int)*a->data.len);
	a->symbol.sig = (COMPLEX *)
				malloc(sizeof(COMPLEX)*a->symbol.len);
	a->noise.sig = (COMPLEX *)malloc(sizeof(COMPLEX)*a->noise.len);
	if(a->data.dat==NULL||a->symbol.sig==NULL||a->noise.sig==NULL){
		printf("Error: _memAlloc_rx(), メモリを確保できません．\n");
		exit(1);
	}
}

void _memFree_tx(TX_SIGNALS *a){
	free(a->data.dat); free(a->symbol.sig);
}
void _memFree_rx(RX_SIGNALS *a){
	free(a->data.dat); free(a->symbol.sig);  free(a->noise.sig);
}

void _bpskMod(SEQ_SIG s, SEQ_DATA data){
	unsigned int i;
	if (s.len != data.len){
		printf("Error: _bpskMod, 長さが一致しません．\n");
		exit(1);
	}
	else {
		for(i=0;i<s.len;i++)
			(s.sig+i)->I = (*(data.dat+i) -0.5)*2.0;
	}
}
void _bpskDem(SEQ_DATA rData, SEQ_SIG rs){
	unsigned int i;
	for(i=0;i<rs.len;i++){
		if((rs.sig+i)->I>0)
			*(rData.dat+i) = 1;
		else
			*(rData.dat+i) = 0;
	}
}

double _randU(void){
	return((double)rand()/(double)RAND_MAX);
}
double _randN(void){
	double s, r, t;
	s = _randU();
	if(s==0.0) s = 0.000000001;
	r = sqrt(-2.0*log(s));
	t  = 2.0*PI*_randU();
	return (r*sin(t));
}
void _randData(SEQ_DATA d){
	unsigned int i;
	double x;
	for(i=0;i<d.len;i++){
		x = _randU();
		if(x >=0.5)
			*(d.dat+i) =1.0;
		else
			*(d.dat+i) =0.0;
	}
}
void _awgn(SEQ_SIG n, double Pn){
	double r, t;	unsigned int i;

	for(i=0;i<n.len;i++){
		(n.sig+i)->I = _randN() * sqrt(Pn/2);
		(n.sig+i)->Q = _randN() * sqrt(Pn/2);
	}
}
double _SNRdB2noisePower(double c_dB){
	return pow(10,(-1)*c_dB/10);
}
void _vectorSum(SEQ_SIG a, SEQ_SIG b, SEQ_SIG c){
	unsigned int i;
	if(a.len != b.len || b.len != c.len){
		printf("Error: _vectorSum, 長さが一致しません．\n");
		exit(1);
	}
	else{
		for(i=0;i<a.len;i++){
			(a.sig+i)->I = (b.sig+i)->I + (c.sig+i)->I;
			(a.sig+i)->Q = (b.sig+i)->Q + (c.sig+i)->Q;
		}
	}
}
double _BER(SEQ_DATA data, SEQ_DATA rData){
	unsigned int i,sum=0;
	double BER;
	if(data.len != rData.len){
		printf("Error: _BER() 長さが一致しません．\n");
		exit(1);
	}
	else{
		for(i=0;i<data.len;i++)
			sum += abs(*(data.dat+i) - *(rData.dat+i));
		BER = (double)sum/data.len;
	}
	return(BER);
}
void _BERprint(unsigned int snr_step, double *SNRdB, double *BER){
	unsigned int i;
	FILE *fp;
	if((fp = fopen("BER.txt","w"))==NULL){
		printf("Error:ファイルを開けません．\n");
		exit(1);
	}
	else{
		for(i=0;i<snr_step;i++){
			printf("%f [dB] BER = %f\n", *(SNRdB+i),*(BER+i));
			fprintf(fp,"%f %f\n", *(SNRdB+i),*(BER+i));
		}
		fclose(fp);
	}
}

int main(void){
    TX_SIGNALS *tx;
    //RX_SIGNALS *rx;
    unsigned int i;
    tx = (TX_SIGNALS *)malloc(sizeof(TX_SIGNALS)*30);//送信機30台分のメモリ確保
    for(i=0;i<30;i++){
        _init_tx(tx+i);
        _memAlloc_tx(tx+i);
    }
    return 0;
}