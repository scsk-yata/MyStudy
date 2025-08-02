%%
N_R = 2; N_T = 2;
Ndata = 100000;

H = MYcompNoise([N_R,N_T],1);
[V_R,LambdaM,V_T] = svd(H);

data = reshape(MYrandData(Ndata*N_T),N_T,Ndata);
bpskSymbols = MYbpskMod(data);

U = V_T * bpskSymbols;
SNRdB = 10;
Pn = 10^(-SNRdB/10);
X = H * U + MYcompNoise([N_R,Ndata],Pn);
Y = V_R' * X;

recoveredData = MYbpskDemod(Y);
MYber(data(1,:),recoveredData(1,:))
MYber(data(2,:),recoveredData(2,:))