Nuser = 2; %ユーザ数
Nsc_per_user = 32; %ユーザあたりのサブキャリヤ数
Nsc = Nuser * Nsc_per_user; %全サブキャリヤ数（SP変換器出力）
N_GI = 8;
NofdmSymbol = 500; %OFDMシンボル数
Ndata = Nsc_per_user * NofdmSymbol; %データビット数[bit]
SNRdB = 20; %SN比[dB]
Lpilot = 2; %パイロットシンボル長
Delay = [0]; %遅延波の遅延量[chip]
Npath = length(Delay); %フェージング経路数
data =  MYrndCode([Ndata,Nuser],0); %ランダムデータ生成
bpskSymbol = MYbpskMod(data); %BPSK変調
Nsymbol = length(bpskSymbol); %シンボル数の検出
spOut = zeros(Nsc,NofdmSymbol); %S/P変換器出力の計算
for userCo = 1:Nuser
    rangeStart = 1 + (userCo-1) * Nsc_per_user;
    rangeEnd = Nsc_per_user*userCo;
    spOut(rangeStart:rangeEnd,:) = reshape(bpskSymbol(:,userCo),Nsc_per_user,NofdmSymbol);
end
% ------------------ リスト7.1(sim3_ofdm.m)の13～30行目をここへ ------------------ 
pilotMat = ones(Nsc,Lpilot);%（イ）パイロットシンボルをサブキャリヤ数分だけ複製
ofdmSymbol_pilot = ifft([pilotMat,spOut]); %（ウ）パイロットシンボルとともにIFFTに入力
gi = ofdmSymbol_pilot((end-N_GI+1):end,:); %（エ）ガードインターバルの作成
ofdmSymbol_pilot_GI = [gi;ofdmSymbol_pilot]; %（エ）ガードインターバルを付加
sOFDM = ofdmSymbol_pilot_GI(:); %（オ）P/S変換器
ofdmSymbolMat = sOFDM * ones(1,Npath);
ofdmSymbolMatDelayed = MYdelayGen(Delay, ofdmSymbolMat);
chOut = ofdmSymbolMatDelayed * ones(Npath,1);
Pn = 10^(-SNRdB/10) /Nsc;
rSig = chOut + MYawgn(Pn,length(chOut),1);
spOutR = reshape(rSig,(Nsc+N_GI),(Lpilot+NofdmSymbol)); %（カ）S/P変換器
spOutR(1:N_GI,:) = []; %（キ）ガードインターバル（GI）除去
fftOut = fft(spOutR); %（ク）FFT
pilotMatRx = fftOut(:,1:Lpilot); %（ケ）パイロットシンボルの抽出
ofdmSymbolRx = fftOut(:,(Lpilot+1):end); %ofdmシンボルからデータの抽出
chCoeff = mean(pilotMatRx,2);
phaseShift = chCoeff./abs(chCoeff) * ones(1,NofdmSymbol); %（コ）位相変化量の推定
ofdmSymbolRxCompensated = ofdmSymbolRx .* conj(phaseShift);%（サ）位相補償
%================================================





ofdmSymbolRx_user = zeros(Nsc,NofdmSymbol);
for userCo = 1:Nuser
    rangeStart = 1 + (userCo-1) * Nsc_per_user;
    rangeEnd = Nsc_per_user*userCo;
    ofdmSymbolRx_user = ofdmSymbolRxCompensated(rangeStart:rangeEnd,:);
    rData = MYbpskDem(MYvec(ofdmSymbolRx_user));
    BER = MYber(data(:,userCo),rData);
    disp(['* ユーザ',num2str(userCo),'のBER: ',num2str(BER)])
end
