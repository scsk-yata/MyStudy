function[snrdB] = MYsnrdB(s,r)
% corrcoefは相関係数行列を計算
% SNR（またはSINR)の計算 
% 引数　s: SNR計算対象の信号ベクトル（x×1），r: 参照信号ベクトル（y×1）
% 　　　　　※長さxとyは同じである必要はない．短いほうが有効．
% 戻り値　snr：計算結果のSNR（真数）or (dB)
length1 = length(s);
length2 = length(r);
length3 = min(length1,length2);
coef2_tmp = corrcoef(s(1:length3),r(1:length3));
coef2 = coef2_tmp(1,2); % 相互相関だけ取り出す
snrdB = 10*log10(abs(coef2)^2 / (1-abs(coef2)^2) );
return