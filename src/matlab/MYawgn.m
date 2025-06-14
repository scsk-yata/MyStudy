function [n] = MYawgn(Pn,rn,cn)
% 複素AWGN発生器
% [n] = MYawgn(SNRdB,rn,cn)
% 引数　Pn:雑音電力，rn:行数，cn:列数
% 戻り値 n（rn×cn）
n=(randn(rn,cn) + 1j*randn(rn,cn))*sqrt(Pn/2);
end
