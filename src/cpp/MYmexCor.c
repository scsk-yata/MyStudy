#include "mex.h" //matlabエディタを開いてc言語の拡張子を指定して編集，実行する
void MYmexCor(double *corR, double *corI, double *weightR, double *weightI,
 double *inputR, double *inputI, int weightLen, int inputLen, int itemNum){

int c1,c2;
double sumR, sumI;
for(c1=0;c1<iteNum;c1++){
    sumR=sumI=0.0;
    for(c2=0;c2<weightLen;c2++){
        sumR += *(weightR+c2) * *(inputR+c1+c2) - *(weightI+c2) * *(inputI+c1+c2);
        sumI += *(weightR+c2) * *(inputI+c1+c2) + *(weightI+c2) * *(inputR+c1+c2);
    }
    *(corR+c1) = sumR; *(corI+c1) = sumI;
}
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]){
double *corR, *corI, *inputR, *inputI, *weightR, *weightI;
int weightLen, inputLen, iteNum;
if(nrhs!=2) mexErrMsgTxt("2 inputs required.");
if(nlhs!=1) mexErrMsgTxt("1 outputs required.");


}