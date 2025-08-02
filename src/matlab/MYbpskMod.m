function[BPSKsymbol] = MYbpskMod(data)
% BPSK変調器
% 引数：　data（列ベクトル)
% 戻り値：bpskSymbol（列ベクトル)
BPSKsymbol = ones(size(data));
BPSKsymbol(data==0) = -1;
return
%bpskSymbol = data;
%bpskSymbol(bpskSymbol==0) = -1;