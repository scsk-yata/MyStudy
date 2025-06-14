function [corOut] = MYcorrelator(w,sig)
% 相関器
% 引数　w: 重み係数（列方向に重み係数），sig: 入力信号（列ベクトル）
% 戻り値　corOut: 相関器出力（入力信号sigと同じサイズ）
sizeW = size(w);
Lw = sizeW(1); %重み係数の長さ
Nw = sizeW(2); %重み係数の種類：複数の重み係数による相関器出力を同時に計算できます。
corIn = [sig; zeros((Lw-1),1)]; %信号末尾に(Nw-1)個の0を付加
corOut = zeros(length(sig),Nw);
for co = 1:length(corOut)
    corOut(co,:) = w' * corIn(co:(co+Lw-1));
end
end
