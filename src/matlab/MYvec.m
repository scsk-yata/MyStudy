function[v] = MYvectorize(x)
% 行列の列ベクトル化 [v] = MYvectorize(x)
% 【入力】
% x: 行列
% 【出力】
% v: 列に積み上げられたx

v = x(:);
return