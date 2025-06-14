Ndata = 100; %データビット数[bit]
SNRdB = 10; %SN比[dB]
Nchip = 100; %拡散系列長[chip]
Delay = [0;10]; %遅延波の遅延量[chip]
Npath = length(Delay); %フェージング経路数
Lss = Ndata * Nchip; %スペクトル拡散信号の長さ
Nsnapshot = 100; %スナップショット数
data =  MYrndCode([Ndata,1],0);
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol); %シンボル数の検出
spCode = MYrndCode([Nchip,1],1);
ssSig = spCode * bpskSymbol.';
ssSig = ssSig(:);
outputSNR_RAKE = zeros(1,Nsnapshot);
outputSNR = zeros(1,Nsnapshot);
for snpCo = 1:Nsnapshot
    ssSigMat = ssSig * ones(1,Npath);
    ssSigMatDelayed = MYdelayGen(Delay, ssSigMat);
    chCoeff = MYchCoeff(Npath,1); %チャネル係数の生成
    chOut = ssSigMatDelayed * chCoeff;
    Pn = 10^(-SNRdB/10) * Nchip;
    rSig = chOut + MYawgn(Pn,Lss,1);
    corOut = MYcorrelator(spCode,rSig); %相関器出力の計算
    corOut_rshp = reshape(corOut,Nchip,Ndata);
    rakeW = zeros(Nchip,1);
    rakeW(Delay+1) = chCoeff;
    y_rake = rakeW' * corOut_rshp;
    outputSNR_RAKE(snpCo) = MYsnr(bpskSymbol, y_rake);
    w = zeros(Nchip,1);
    w(Delay(1)+1) = 1;
    y = w' * corOut_rshp;
    outputSNR(snpCo) = MYsnr(bpskSymbol, y);
end
aveOutputSNR_RAKE = MYdB(mean(outputSNR_RAKE));
aveOutputSNR = MYdB(mean(outputSNR));
disp(['*RAKE合成出力の平均受信SN比: ',num2str(aveOutputSNR_RAKE),'[dB]'])
disp(['*遅延波を合成しない時の平均受信SN比: ',num2str(aveOutputSNR),'[dB]'])
