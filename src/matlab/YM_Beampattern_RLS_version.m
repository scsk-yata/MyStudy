%% 
clear;
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
% 
PSI = exp(-1i*2*pi*d*sin(DOAvector*deg2rad));
A = (ones(N_R,1)*PSI).^( (0:N_R-1).' * ones(1,N_P) );
%S = ones(N_P,K);
S = MYbpskMod(reshape(MYrandData(N_P*K),N_P,K));
X = A*S + MYcompNoise([N_R,K],Pn);
% eyeは単位行列を生成する
w = zeros(N_R,1);
zeta = 10000*eye(N_R);
Beta = 1;
for k = 1:K
    J = (1/Beta) * zeta * X(:,k) / ( 1+(1/Beta)*X(:,k)'*zeta*X(:,k) );
    w = w + J*conj(S(1,k)-w'*X(:,k));
    zeta = (1/Beta) * (eye(N_R)-J*X(:,k)') * zeta;
end

[doa,antPat_dB] = MYantPattern(N_R,w,d);
plot(doa,antPat_dB);