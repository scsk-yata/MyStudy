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

PSI = exp(-1i*2*pi*d*sin(DOAvector*deg2rad));
A = (ones(N_R,1)*PSI).^( (0:N_R-1).' * ones(1,N_P) );
%S = ones(N_P,K);
S = MYbpskMod(reshape(MYrandData(N_P*K),N_P,K));
X = A*S + MYcompNoise([N_R,K],Pn);

Rxx = X * X';
r = S(1,:).';
w = inv(Rxx)*X * conj(r); %Rxx\Xの方が良いらしい
%w = Rxx\X * conj(r); %Rxx\Xの方が良いらしい 結果同じ
doa = -90:90;
A_antPat = MYsteer(N_R,d,doa);
P_theta = abs(w' * A_antPat).^2;
antPat_dB = P_theta/max(P_theta);

figure
plot(doa,10*log10(P_theta))

SNRin = 10^(SNRdB/10);
SNRoutdB = 10*log10( abs(w'*A(:,1))^2 / (w'* w) * SNRin )