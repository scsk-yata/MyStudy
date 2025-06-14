%% 
N_R = 4;
K = 1000;
Ntest = 100;
SNRdB = 10;

s = MYbpskMod(MYrandData(K));
testSeq = s(1:Ntest);
h = randn(N_R,1) .* exp(1i*rand(N_R,1)*2*pi);
h = h/norm(h);
Pn = 10^(-SNRdB/10);
X = h*s.' + MYcompNoise([N_R,K],Pn);

w_est = X(:,1:Ntest) * conj(testSeq);
y_est = w_est' * X;
outputSNR_est = MYsnrdB(y_est,s);
% matlabのeigは昇順にも降順にもなっていない
Rxx = X * X';
[eVector,eValue] = eig(Rxx);
[sortValue,sortIndex] = sort(diag(eValue))
w_evd = eVector(:,sortIndex(end));
y_evd = w_evd' * X;
outputSNR_evd = MYsnrdB(y_evd,s);

outputSNR_theory = 10*log10(sum(abs(h).^2)/Pn);

disp(['方法1による出力SN比:',num2str(outputSNR_est),'[dB]'])
disp(['方法2による出力SN比:',num2str(outputSNR_evd),'[dB]'])
disp(['理論式による出力SN比:',num2str(outputSNR_theory),'[dB]'])