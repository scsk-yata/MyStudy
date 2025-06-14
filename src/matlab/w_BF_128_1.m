%% 仰角φ,方位角θ方向へビームフォーミングを行うための重み行列を作成する関数

% w(φ,θ)は（縦方向の素子数）×（横方向の素子数）サイズの行列であり, この行列の各要素を,アレーアンテナ
% の各素子から送信される送信信号s(縦方向の番号,横方向の番号)に乗算することで,全ての信号を同じ方向へ強めることができる

function W = w_BF_128_1(hor_angle,ver_angle)

N_ver = 8;    % 垂直方向の素子数
N_hor = 16;   % 水平方向の素子数
W = zeros(N_ver*N_hor,1);   % 重み行列のサイズを設定
c = 3e8;    % 光速
frequency = 5.2e9;  % 中心周波数f 5.2 GHzだとして考えてみる
lambda = c/frequency;  % 波長λ
d = lambda/2;  % 素子間距離

for nx=1:N_hor
    for nz=1:N_ver
        W((nx-1)*N_ver+nz,1) = exp(-1j*2*pi*(d/lambda)*(nx*cosd(hor_angle)*sind(ver_angle)+nz*cosd(ver_angle)));
        %W((nz-1)*N_hor+nx,1)=exp(-1j*2*pi*d/lambda*(nx*cosd(hor_angle)*sind(ver_angle)+nz*cosd(ver_angle)));
    end                      % 各素子位置に対応する重みを生成する
end

end