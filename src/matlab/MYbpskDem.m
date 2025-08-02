function [rData] = MYbpskDem(rSig)
% BPSK復調器
% 引数　rSig：受信信号（列or行ベクトル）
% 戻り値　rData：受信データ（列ベクトル）
rData = ones(size(rSig));
rData(rSig<0)=0;
end
