Ndata = 1000; %データビット数[bit]
Nchip = 100; %拡散系列長[chip]
UserPower = [1,100]; %端末ごとの電力：遠近問題を試す
Nuser = length(UserPower); %ユーザー数（送信機の数）の検出
SNRdB = 20; %第１ユーザ（送信機）の電力UserPower(1)に対するSN比[dB]
Lss = Ndata * Nchip; %スペクトル拡散信号の長さ
data =  MYrndCode([Ndata,Nuser],0); %データ系列の生成
bpskSymbol = MYbpskMod(data); %BPSK変調
Nsymbol = length(bpskSymbol); %シンボル数の検出
spCode = MYrndCode([Nchip,Nuser],1); %拡散系列の発生
ssSig = spCode * diag(sqrt(UserPower)) * bpskSymbol.'; %スペクトル拡散信号の発生
ssSig = ssSig(:); %列ベクトル化
Pn = 10^(-SNRdB/10) * sqrt(UserPower(1)) * Nchip;
rSig = ssSig + MYawgn(Pn,Lss,1);
corOut = MYcorrelator(spCode,rSig);
for userCo = 1:Nuser
    corOut_rshp = reshape(corOut(:,userCo),Nchip,Ndata);
    rData = MYbpskDem(corOut_rshp(1,:));
    BER = MYber(data(:,userCo),rData.');
    disp(['* 端末',num2str(userCo),'のBER：',num2str(BER)])
end
