function [chCoeff] = MYchCoeff(N, Pa)
% ランダムチャネル係数（振幅：レイリー，位相：一様分布）を生成する関数
% 引数　N: チャネル係数の数，Pa: 平均電力
% 戻り値　chCoeff: チャネル係数（N×1)
rndPhase = rand(N,1)*2*pi; 
rylAmp = MYrylrnd(Pa, N);
chCoeff = rylAmp.*exp(1j*rndPhase);
end
