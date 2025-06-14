%% 
deg2rad = pi/180;
Theta_Ddeg = -20;
Theta_Ideg = 30;
N_R = 4;
d = 0.5;
K = 100;
SNRdB = 10;
DOAvector = [Theta_Ddeg,Theta_Ideg];
N_P = length(DOAvector);
Pn = 10^(-SNRdB/10);
% DOAvectorと同じサイズ
PSI = exp(-1i*2*pi*d*sin(DOAvector*deg2rad));
A = (ones(N_R,1)*PSI).^( (0:N_R-1).' * ones(1,N_P) );
%S = ones(N_P,K); % 指数の中も4×2サイズ
S = MYbpskMod(reshape(MYrandData(N_P*K),N_P,K));
X = A*S + MYcompNoise([N_R,K],Pn);
% 到来パス数×到来（送信）サンプル数
w = zeros(N_R,1);
mu = 0.01;
errorRecord = zeros(1,K);
for k = 1:K
    errorRecord(k) = S(1,k)-w'*X(:,k);
    w = w + mu * X(:,k)*conj(S(1,k)-w'*X(:,k));
end
% for文の中は(1,K)のベクトル
[doa,antPat_dB] = MYantPattern(N_R,w,d);
plot(doa,antPat_dB);

figure
plot(abs(errorRecord))