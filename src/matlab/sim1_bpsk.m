%%
Ndata = 100000; %�f�[�^�r�b�g��[bit]
SNRdB = 1; %SN��[dB]
data = MYrndCode([Ndata,1],0);
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol);
Pn = 10^(-SNRdB/10);
rSig = bpskSymbol + MYawgn(Pn,Nsymbol,1);
rData = MYbpskDem(rSig);
BER = MYber(data,rData)
BER_theory = .5*erfc(sqrt(10^(SNRdB/10))) %���Ƃ����������_�l .5��1/2�������Ă���
disp(['* BER = ',num2str(BER)])
disp(['* BER_theory = ',num2str(BER_theory)])