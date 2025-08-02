function[channelResponse] = MYdelayProfile(delay,Tau1,Mitigation_dB)
% Tau1分の遅延波の電力減衰量をmitigationとしたい場合に，Delta_tauを以下の式で設定
mitigation = 10^(Mitigation_dB/10);
Delta_tau = -Tau1 / log(mitigation);
Ndelay = length(delay);
P_tau = exp(-delay/Delta_tau);
randPhase = rand(Ndelay,1) * 2 * pi;
randAmp = sqrt(randn(Ndelay,1).^2 + randn(Ndelay,1).^2) .*sqrt(P_tau/2);
channelResponse = randAmp .*exp(1i*randPhase);
return