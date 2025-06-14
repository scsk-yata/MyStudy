N_T = 4; %送信アンテナ数
N_R = 2; %受信アンテナ数
Ndata = 1000; %（MIMO“パイプ”1本あたりの）送信データ長
SNRdB = 100; %SN比（端末Aの1本目のパイプにおけるSN比）
data_A = MYrndCode([N_R,Ndata],0); %端末Aへのデータ
data_B = MYrndCode([N_R,Ndata],0); %端末Bへのデータ
bpskSymbols_A = MYbpskMod(data_A); %BPSK変調
bpskSymbols_B = MYbpskMod(data_B); %BPSK変調
bpskSymbols = [bpskSymbols_A; bpskSymbols_B];%端末AとBへのデータを一つの行列にまとめる。
H_A = MYawgn(1,N_R,N_T);%     （本当はテスト系列を送って受信機でチャネル推定しフィードバック）
H_B = MYawgn(1,N_R,N_T);%     （本当はテスト系列を送って受信機でチャネル推定しフィードバック）
[V_R_A,Lambda_A,V_T_A] = svd(H_A);
Vn_A = V_T_A(:,3:4); 
[V_R_B,Lambda_B,V_T_B] = svd(H_B);
Vn_B = V_T_B(:,3:4);
H_A_tilda = H_A * Vn_B;
H_B_tilda = H_B * Vn_A;
[V_R_A_tilda,Lambda_A_tilda,V_T_A_tilda] = svd(H_A_tilda);
[V_R_B_tilda,Lambda_B_tilda,V_T_B_tilda] = svd(H_B_tilda);
W_T_A = Vn_B * V_T_A_tilda;
W_T_B = Vn_A * V_T_B_tilda;
U_A = W_T_A*bpskSymbols_A; 
U_B = W_T_B*bpskSymbols_B;
Pn = 10^(-SNRdB/10)*Lambda_A_tilda(1);
X_A = H_A*(U_A + U_B) + MYawgn(Pn,N_R,Ndata);
X_B = H_B*(U_A + U_B) + MYawgn(Pn,N_R,Ndata);
Y_A = V_R_A_tilda'*X_A;
Y_B = V_R_B_tilda'*X_B;
rData_A= MYbpskDem(Y_A);
rData_B= MYbpskDem(Y_B);
for pipeCo = 1:N_R
    BER_A = MYber(data_A(pipeCo,:),rData_A(pipeCo,:));
    disp(['* 端末Aのパイプ',num2str(pipeCo),'のBER：',num2str(BER_A)])
    BER_B = MYber(data_B(pipeCo,:),rData_B(pipeCo,:));
    disp(['* 端末Bのパイプ',num2str(pipeCo),'のBER：',num2str(BER_B)])
end
