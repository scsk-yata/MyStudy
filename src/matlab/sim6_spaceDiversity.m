Ndata = 1000; %データビット数[bit]
SNRdB = 10; %アンテナ１本あたりの平均SN比[dB]
N_R = 4; %受信アンテナ本数
Nsnapshot = 100; %スナップショット数
data = MYrndCode([Ndata,1],0);
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol);
outputSNR_MRC = zeros(1,Nsnapshot);
outputSNR = zeros(1,Nsnapshot);
for snpCo = 1:Nsnapshot
    Pn = 10^(-SNRdB/10);
    chCoeff = MYchCoeff(N_R,1); %チャネル係数の発生
    rSig = chCoeff * bpskSymbol.' + MYawgn(Pn,N_R,Nsymbol);
    y_MRC = chCoeff' * rSig; %最大比合成を行った出力
    outputSNR_MRC(snpCo) = MYsnr(bpskSymbol, y_MRC);
    y = ones(1,N_R) * rSig; %単純にアンテナ受信信号を足した出力
    outputSNR(snpCo) = MYsnr(bpskSymbol, y);
end
aveOutputSNR_MRC = MYdB(mean(outputSNR_MRC));
aveOutputSNR = MYdB(mean(outputSNR));
disp(['* MRC合成の平均受信SN比: ',num2str(aveOutputSNR_MRC),'[dB]'])
disp(['* アンテナ受信信号を単純にたした時の平均受信SN比: ',num2str(aveOutputSNR),'[dB]'])
