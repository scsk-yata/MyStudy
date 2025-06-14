%% 
Ndata = 10; 
SNRdB = 20; 
Nchip = 100; % 拡散系列長[chip]
Lss = Ndata * Nchip; % スペクトル拡散信号の長さ[chip]
Delay = [0;10]; % 選択性フェージングで生じる遅延量[chip]
Npath = length(Delay); % 経路数：Delayの要素数を経路数とする。
data =  MYrndCode([Ndata,1],0); 
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol);
spCode = MYrndCode([Nchip,1],1); %拡散系列として使う2値(-1,1)ランダム系列生成
ssSig = spCode * bpskSymbol.';
ssSig = ssSig(:); 
ssSigMat = ssSig * ones(1,Npath);
ssSigMatDelayed = MYdelayGen(Delay, ssSigMat);
chOut = ssSigMatDelayed * ones(Npath,1);
Pn = 10^(-SNRdB/10) * Nchip;
rSig = chOut + MYawgn(Pn,Lss,1);
corOut = MYcorrelator(spCode,rSig); %相関器出力の計算
figure; plot(real(corOut))
corOut_rshp = reshape(corOut,Nchip,Ndata);%ピーク点の抽出（図7-17参照）
rData = MYbpskDem(corOut_rshp(1,:));
BER = MYber(data,rData.')
