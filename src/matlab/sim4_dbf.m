%%
Ndata = 1000; %データビット数[bit]
SNRdB = 10; %アンテナ１本あたりのSN比[dB]
N_R = 4; %受信アンテナ本数
d = .5; %波長で正規化したアンテナ間隔
DOAdeg = 30; %信号到来角度[度]
pointingDOAdeg = 15; %受信アンテナの指向性の方向　電波の到来方向と異なる
data = MYrndCode([Ndata,1],0); bpskSymbol = MYbpskMod(data); %ランダムデータ生成とBPSK変調
Nsymbol = length(bpskSymbol);%シンボル数の検出
Pn = 10^(-SNRdB/10); %雑音電力の計算
steer1 = MYsteer(N_R,d,DOAdeg);%信号ステアリングベクトルの計算
rSig = steer1 * bpskSymbol.'+ MYawgn(Pn,N_R,Nsymbol); %受信信号の計算（式（38）参照）
y1 = steer1' * rSig; %受信信号のステアリングベクトルを重み係数として使ったときの出力計算
outputSNR1 = MYsnr(bpskSymbol, y1); %その時の出力SNRの計算
steer2 = MYsteer(N_R,d,pointingDOAdeg); %pointingDOAdegで設定した方向に指向性を向けるステアリングベクトル
y2 = steer2' * rSig; %その時の受信信号の計算
outputSNR2 = MYsnr(bpskSymbol, y2); %その時の出力SN比の計算
disp(['* 指向性を信号到来方向（',num2str(DOAdeg),'度）に向けたときの受信SN比:',num2str(MYdB(outputSNR1)),'[dB]'])
disp(['* 指向性を異なる方向（',num2str(pointingDOAdeg),'度）に向けたときの受信SN比:',num2str(MYdB(outputSNR2)),'[dB]'])
[doa1,antPat_dB1] = MYantPattern(N_R,steer1,d); %steer1を使った受信アンテナの指向性の計算
[doa2,antPat_dB2] = MYantPattern(N_R,steer2,d); %steer2を使った受信アンテナの指向性の計算
figure; plot(doa1,antPat_dB1,doa2,antPat_dB2); axis([-90 90 -30 0]) %指向性の描画
