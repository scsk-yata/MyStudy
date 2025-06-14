function [rS] = MYrylrnd(Pa, L)
% 平均電力をPaとするレイリー乱数の生成
% 引数　Pa: 平均電力（1×1），L: 乱数の長さ（1×1）
% 戻り値　rS: レイリー乱数（L×1）
Npath = 20;
randPhase = rand(Npath,L) *2*pi;
s = exp(1j*randPhase)*sqrt(Pa/Npath);
rS = abs(sum(s).');
end
