DOAdeg = 30; %先に来る信号到来角度[度]
DOAdeg_delayed = -10; %遅延波の信号到来角度[度]
Delay = [0,1]; %各信号の遅延量
Nsignal = length(Delay); %信号数
Ndata = 1000; %データビット数[bit]
SNRdB = 10; %アンテナ1本あたりのSN比[dB]
N_R = 4; %受信アンテナ本数
d = .5; %波長で正規化したアンテナ間隔
data = MYrndCode([Ndata,1],0);
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol);%シンボル数の検出
bpskSymbols = bpskSymbol * ones(1,Nsignal); %シンボルのコピー
bpskSymbols = MYdelayGen(Delay, bpskSymbols);
Pn = 10^(-SNRdB/10);
steers = MYsteer(N_R,d,[DOAdeg,DOAdeg_delayed]);
rSig = steers * bpskSymbols.' + MYawgn(Pn,N_R,Nsymbol);
Rxx = rSig * rSig'; 
gamma_rx = rSig * conj(bpskSymbol(:,1));
w = inv(Rxx) * gamma_rx; 
y_wi = w'* rSig; % Wiener解を重み係数にしたときのアンテナ出力
outputSNR_wi = MYsnr(bpskSymbol, y_wi); % その出力SN比
y = ones(1,N_R) * rSig; % アンテナ受信信号を何もせずたしたときのアンテナ出力
outputSNR = MYsnr(bpskSymbol, y); % その出力SN比
disp(['* Wiener解を使ったときの受信SN比: ',num2str(MYdB(outputSNR_wi)),'[dB]'])
disp(['* アンテナ受信信号をそのまま足しただけの受信SN比:',num2str(MYdB(outputSNR)),'[dB]'])
[doa,antPat_dB_wi] = MYantPattern(N_R,w,d); %アンテナパターンの計算
[doa,antPat_dB] = MYantPattern(N_R,ones(4,1),d); %アンテナパターンの計算
figure; plot(doa,antPat_dB_wi,doa,antPat_dB); axis([-90 90 -30 0]) %アンテナパターンの描画