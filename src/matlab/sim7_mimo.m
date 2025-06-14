N_T = 2; %送信アンテナ数
N_R = 2; %受信アンテナ数
Ndata = 1000; %データ長
SNRdB = 100; %[dB] 平均SN比（もっとも太いパイプで定義）
data = MYrndCode([N_T, Ndata],0); %送信データ発生
bpskSymbols = MYbpskMod(data); %BPSK変調
H = MYawgn(1,N_R,N_T); %チャネル係数行列の発生
[V_R,LambdaM,V_T] = svd(H); %特異値分解
U = V_T * bpskSymbols; %送信重み係数のかけ算
Pn = 10^(-SNRdB/10) * LambdaM(1); %雑音電力の計算（パイプ1で定義するように）
X = H * U + MYawgn(Pn,N_R,Ndata); %受信信号の計算
Y = V_R' * X; %受信重み係数の乗算
rData = MYbpskDem(Y); %復調
for pipeCo = 1:N_R
    BER = MYber(data(pipeCo,:),rData(pipeCo,:));
    disp(['* パイプ#',num2str(pipeCo),'のBER：',num2str(BER)])
end
