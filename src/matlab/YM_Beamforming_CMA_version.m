%% 
deg2rad = pi/180;
Theta_Ddeg = -20;
Theta_Ideg = 30;
N_R = 4;
d = 0.5; % 長さの単位は波長で正規化されている
K = 100;
SNRdB = 10;
DOAvector = [Theta_Ddeg,Theta_Ideg];
N_P = length(DOAvector);
Pn = 10^(-SNRdB/10);
% PSIは
PSI = exp(-1i*2*pi*d*sin(DOAvector*deg2rad));
A = (ones(N_R,1)*PSI).^( (0:N_R-1).' * ones(1,N_P) );
%S = ones(N_P,K);
S = MYbpskMod(reshape(MYrandData(N_P*K),N_P,K));
S(2,:) = MYcompNoise(size(S(1,:)),1);
X = A * S + MYcompNoise([N_R,K],Pn);
w = zeros(N_R,1); w(1,1) = 1;
mu = 0.0001;
sigmaCMA = N_R;
% 
for k = 1:K
    y = w'* X(:,k);
    w = w - 4*mu*X(:,k)*conj(y)*(abs(y)^2-sigmaCMA^2);
end

[doa,antPat_dB] = MYantPattern(N_R,w,d);
plot(doa,antPat_dB)