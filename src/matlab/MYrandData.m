function[data] = MYrandData(Ndata)
% 縦方向のベクトル
dataSeq = randn(Ndata,1);
data = zeros(Ndata,1);
data(dataSeq>0) = 1;
return