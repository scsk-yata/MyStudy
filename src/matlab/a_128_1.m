%% 受信端末が仰角φ,方位角θに位置する場合の,重み行列に乗算する係数行列を作成する関数

% a(φ,θ)は（縦方向の素子数）×（横方向の素子数）サイズの行列であり, この行列の各要素を,
% ビームフォーミング用の重み行列の対応する各要素に乗算する

function a = a_128_1(ang_hor,ang_ver)    % 方位角,仰角

N_ver = 8;    % 垂直方向の素子数
N_hor = 16;   % 水平方向の素子数
a = zeros(N_ver*N_hor,1);   % 重み行列のサイズを設定
c = 3e8;    % 光速
frequency = 5.2e9;  % 中心周波数f 5.2 GHzだとして考えてみる
lambda = c/frequency;  % 波長λ
d = lambda/2;  % 素子間距離


for nx=1:N_hor
    for nz=1:N_ver
        %a((nz-1)*N_hor+nx,1) = exp(1j*2*pi*d/lambda*(nx*cosd(ang_hor)*sind(ang_ver)+nz*cosd(ang_ver)));
        a((nx-1)*N_ver+nz,1) = exp(1j*2*pi*d/lambda*(nx*cosd(ang_hor)*sind(ang_ver)+nz*cosd(ang_ver)));
    end
end

end