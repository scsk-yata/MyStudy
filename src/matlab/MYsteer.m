function A = MYsteer(N_R,d,DOAdeg)
%Matlabは()でもベクトルを作れる
deg2rad = pi/180;
DOArad = DOAdeg * deg2rad;
N_P = length(DOAdeg); %　到来方向情報ベクトル
PSI = exp(-1i*2*pi*d*sin(DOArad));
A = (ones(N_R,1)*PSI).^((0:N_R-1).'*ones(1,N_P));
return
%{
function[A] = MYsteer(N_R,d,DOAdeg)
% 線形アレーのステアリングベクトルを出力
% 引数　N_R: アンテナ数（1×1），d: 波長で正規化したアンテナ間隔（1×1）
% 　　　DOAdeg: 信号到来角度[度]（行or列ベクトル）
% 戻り値　A: 複数のステアリングベクトルを含む行列
% 　　　　　（列方向にステアリングベクトルを持ち，行方向に並べた行列）
DOArad = DOAdeg * pi/180;
N_P = length(DOAdeg);
PSI = exp(-1j*2*pi*d*sin(DOArad));
A = (ones(N_R,1) * PSI).^((0:(N_R-1)).'*ones(1,N_P));
end
%}