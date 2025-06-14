function [rndCode] = MYrndCode(codeSize,Type)
% [0,1]または[1,-1]のランダム系列を生成
% 引数　codeSize: 生成するランダム系列のサイズ[行数×列数]
% 　　　Type: タイプ(0or1)   0:[0,1], 1:[-1,1]
% 戻り値　rndCode: ランダム系列（列ベクトル）
rndCode = randn(codeSize);
rndCode(rndCode>0) = 1;
if Type == 0
    rndCode(rndCode<=0) = 0;
else
    rndCode(rndCode<=0) = -1;
end
end
