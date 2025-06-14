%% ビームの指向性パターン　16エリア
clear
clc
rng('shuffle');

%% 初期設定
c = 3e8;                   % 光速
fc = 5.2e9;
lambda = c/fc;       % 波長λは光速を周波数で割ることで得られる
d_antenna = lambda/2;              % 隣接する素子間距離
N_ver = 8;                 % 垂直方向の素子数
N_hor = 16;                % 水平方向の素子数

N_subcar = 288;
N_RB = 24;
N_subcar_1RB = N_subcar/N_RB;

d_subcar = 120e3;           % サブキャリア間隔, 120 kHzとする
bandwidth = d_subcar * N_subcar;    % 帯域幅はフレキシブル　大きければ大きいほど雑音電力が大きくなる
bandwidth_dB = 10*log10(bandwidth);
f_range = fc-(bandwidth/2)+d_subcar/2 : d_subcar : fc+(bandwidth/2)-d_subcar/2;
noise_1Hz_dBm = -174;                 % 単位帯域幅 1Hzあたりの雑音電力
Noise_Figure_dB = 9;
noise_variance_dBm = noise_1Hz_dBm + bandwidth_dB + Noise_Figure_dB;
Tx_1element_mW = 1000/(N_ver*N_hor);       % 各素子当たり何mWなのか 振幅は1/√アンテナ素子数 となる
Tx_1element_dBm = 10*log10(Tx_1element_mW);    % dBmで表示
SN_dB_1element = Tx_1element_dBm - noise_variance_dBm;
Desire_power_dBm = Tx_1element_dBm + 10*log10((N_ver*N_hor)^2);
% SNRの値を設定 雑音の電力, -174dBを利用してSNを計算
SN_dB = Desire_power_dBm - noise_variance_dBm;
SN_ratio = 10^(SN_dB/10);
% 伝搬ロスの係数, 距離のple乗に比例して減衰する UMa cellモデル
N_beam = N_subcar;


N_TP = 2;
Nu_1RB = 1;
Nu_all = 32;
Nu_1TP = 16;
Na_1TP = 16;

ple_LOS = 2.20;
ple_NLOS = 3.67;
d_LOS = 36;

d_TP = 500;
d_edge = d_TP/2;



%% 仰角と方位角の範囲を決める
d_hor = 180/N_beam;                  % 仰角,方位角の刻み間隔,これがビームの本数を決める
anglerange_hor = d_hor:d_hor:180;        % 水平方向の角度の下限から上限
hor_index = anglerange_hor/d_hor;        % 水平方向のインデックス

%% 基地局側でビームフォーミング重み行列を生成する
% ビームを向ける角度,ビームを向ける方向,仰角方位角を変化させていく
W = zeros(N_ver*N_hor,N_beam);
A11 = zeros(N_ver*N_hor,N_beam);

for bh = hor_index
    W(:,bh) = w_BF_128_1(bh*d_hor,90);
end              % bh番目のビームパターンの重みをbh列目に代入する

for h = hor_index
    A11(:,h) = a_128_1(h*d_hor,90);
end

%% 値を格納する箱を用意
% 総アンテナ数×サブキャリア数
Amp_ak = ones(N_hor*N_ver,N_subcar)*sqrt( (10^(Tx_1element_dBm/10))/Nu_1RB );     % 振幅を設定( mW )

power_uuk1 = zeros(Na_1TP,Na_1TP,N_subcar);
power_uuk2 = zeros(Na_1TP,Na_1TP,N_subcar);

power_uuk_all = zeros(Nu_all,Nu_all,N_subcar);


UC1 = combnk(1:Nu_1TP,Nu_1RB);
UC2 = combnk(Nu_1TP+1:Nu_all,Nu_1RB);
UC12 = zeros(length(UC1)*length(UC2), Nu_1RB*2);

for c1 = 1:length(UC1)
    for c2 = 1:length(UC2)
        UC12((c1-1)*length(UC2)+c2,:) = horzcat( UC1(c1,:),UC2(c2,:) );
    end
end


throughput_UC12 = zeros(1,length(UC12));



%% AWGNを生成する
Npw = 10^(noise_variance_dBm/10);         % ノイズの電力(mW)

PL_dB_tu = zeros(N_TP,Nu_all);

H_uak = ones(Nu_all,N_hor*N_ver,N_subcar);
H_1uak = ones(Nu_all,N_hor*N_ver,N_subcar);
H_2uak = ones(Nu_all,N_hor*N_ver,N_subcar);

b = zeros(Nu_all,N_subcar);

P_tubk = zeros(N_TP,Nu_all,N_beam,N_subcar);


%% 各受信端末の基地局から見た距離

hor_tu = zeros(N_TP,Nu_all);
d_tu = zeros(N_TP,Nu_all);


for u = 1:Na_1TP
    hor_tu(1,u) = (180/Na_1TP)*(u-1)+(180/Na_1TP)*1/2;
    d_tu(1,u) = d_edge/cosd(0)*1/2;
    d_tu(2,u) = sqrt( d_tu(1,u)^2 + d_TP^2 - 2*d_tu(1,u)*d_TP*cosd(180-hor_tu(1,u)) );
    hor_tu(2,u) = asind( d_tu(1,u)*sind(180-hor_tu(1,u))/d_tu(2,u) );
    %
    [PL_dB_1u,H_ak_1u] = PL_dB_H_ak_CDLOS(d_tu(1,u),hor_tu(1,u));
    [PL_dB_2u,H_ak_2u] = PL_dB_H_ak_CDLOS(d_tu(2,u),hor_tu(2,u));
    PL_dB_tu(1,u) = PL_dB_1u;
    PL_dB_tu(2,u) = PL_dB_2u;
    for k = 1:N_subcar
        H_1uak(u,:,k) = H_ak_1u(:,k);
        H_2uak(u,:,k) = H_ak_2u(:,k);
    end
    %}
end

for u = Na_1TP+1:2*Na_1TP
    hor_tu(2,u) = (180/Na_1TP)*(u-1-Na_1TP)+(180/Na_1TP)*1/2;
    d_tu(2,u) = d_edge/cosd(0)*1/2;
    d_tu(1,u) = sqrt( d_tu(2,u)^2 + d_TP^2 - 2*d_tu(2,u)*d_TP*cosd(hor_tu(2,u)) );
    hor_tu(1,u) = 180 - asind( d_tu(2,u)*sind(hor_tu(2,u))/d_tu(1,u) );
    %
    [PL_dB_1u,H_ak_1u] = PL_dB_H_ak_CDLOS(d_tu(1,u),hor_tu(1,u));
    [PL_dB_2u,H_ak_2u] = PL_dB_H_ak_CDLOS(d_tu(2,u),hor_tu(2,u));
    PL_dB_tu(1,u) = PL_dB_1u;
    PL_dB_tu(2,u) = PL_dB_2u;
    for k = 1:N_subcar
        H_1uak(u,:,k) = H_ak_1u(:,k);
        H_2uak(u,:,k) = H_ak_2u(:,k);
    end
    %}
end

%{
for t = 1:N_TP
    for u = 1:Nu_all
        PL_dB_tu(t,u) = 28.0 + ple_LOS*10*log10(d_tu(t,u)) + 20*log10(fc/(10^9));
    end
end
%}

a11 = a_128_1(hor_tu(1,1),90);
a21 = a_128_1(hor_tu(2,1),90);
a12 = a_128_1(hor_tu(1,2),90);
a22 = a_128_1(hor_tu(2,2),90);
a13 = a_128_1(hor_tu(1,3),90);
a23 = a_128_1(hor_tu(2,3),90);
a14 = a_128_1(hor_tu(1,4),90);
a24 = a_128_1(hor_tu(2,4),90);
a15 = a_128_1(hor_tu(1,5),90);
a25 = a_128_1(hor_tu(2,5),90);
a16 = a_128_1(hor_tu(1,6),90);
a26 = a_128_1(hor_tu(2,6),90);
a17 = a_128_1(hor_tu(1,7),90);
a27 = a_128_1(hor_tu(2,7),90);
a18 = a_128_1(hor_tu(1,8),90);
a28 = a_128_1(hor_tu(2,8),90);
a19 = a_128_1(hor_tu(1,9),90);
a29 = a_128_1(hor_tu(2,9),90);
a110 = a_128_1(hor_tu(1,10),90);
a210 = a_128_1(hor_tu(2,10),90);

a111 = a_128_1(hor_tu(1,11),90);
a211 = a_128_1(hor_tu(2,11),90);
a112 = a_128_1(hor_tu(1,12),90);
a212 = a_128_1(hor_tu(2,12),90);
a113 = a_128_1(hor_tu(1,13),90);
a213 = a_128_1(hor_tu(2,13),90);
a114 = a_128_1(hor_tu(1,14),90);
a214 = a_128_1(hor_tu(2,14),90);
a115 = a_128_1(hor_tu(1,15),90);
a215 = a_128_1(hor_tu(2,15),90);
a116 = a_128_1(hor_tu(1,16),90);
a216 = a_128_1(hor_tu(2,16),90);
a117 = a_128_1(hor_tu(1,17),90);
a217 = a_128_1(hor_tu(2,17),90);
a118 = a_128_1(hor_tu(1,18),90);
a218 = a_128_1(hor_tu(2,18),90);
a119 = a_128_1(hor_tu(1,19),90);
a219 = a_128_1(hor_tu(2,19),90);
a120 = a_128_1(hor_tu(1,20),90);
a220 = a_128_1(hor_tu(2,20),90);

a121 = a_128_1(hor_tu(1,21),90);
a221 = a_128_1(hor_tu(2,21),90);
a122 = a_128_1(hor_tu(1,22),90);
a222 = a_128_1(hor_tu(2,22),90);
a123 = a_128_1(hor_tu(1,23),90);
a223 = a_128_1(hor_tu(2,23),90);
a124 = a_128_1(hor_tu(1,24),90);
a224 = a_128_1(hor_tu(2,24),90);
a125 = a_128_1(hor_tu(1,25),90);
a225 = a_128_1(hor_tu(2,25),90);
a126 = a_128_1(hor_tu(1,26),90);
a226 = a_128_1(hor_tu(2,26),90);
a127 = a_128_1(hor_tu(1,27),90);
a227 = a_128_1(hor_tu(2,27),90);
a128 = a_128_1(hor_tu(1,28),90);
a228 = a_128_1(hor_tu(2,28),90);
a129 = a_128_1(hor_tu(1,29),90);
a229 = a_128_1(hor_tu(2,29),90);
a130 = a_128_1(hor_tu(1,30),90);
a230 = a_128_1(hor_tu(2,30),90);

a131 = a_128_1(hor_tu(1,31),90);
a231 = a_128_1(hor_tu(2,31),90);
a132 = a_128_1(hor_tu(1,32),90);
a232 = a_128_1(hor_tu(2,32),90);
%}

hor_t11 = d_hor:d_hor:180;
d_t11 = d_edge/cosd(0)*1/2*ones(1,round(180/d_hor));
d_t21 = zeros(1,N_beam);
hor_t21 = zeros(1,N_beam);
A21 = zeros(N_ver*N_hor,N_beam);
PL_dB_t21 = zeros(1,N_beam);
PL_t21 = zeros(1,N_beam);

for i = 1:N_beam
    
    d_t21(i) = sqrt( d_t11(i)^2 + d_TP^2 - 2*d_t11(i)*d_TP*cosd(180-hor_t11(i)) );
    hor_t21(i) = asind( d_t11(i)*sind(180-hor_t11(i))/d_t21(i) );

    if round(hor_t21(i)/d_hor) < 1
        hi = 1;
    else
        hi = round(hor_t21(i)/d_hor);
    end
    A21(:,i) = A11(:,hi);

    PL_dB_t21(i) = 28.0 + ple_LOS*10*log10(d_t21(i)) + 20*log10(fc/(10^9));
    PL_t21(i) = 10^(-PL_dB_t21(i)/10);
end






%%
for k = 1:N_subcar
%% 希望信号電力と干渉信号電力
    
    %{
    R_signal11 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*a11*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal21 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*a21*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal12 = sum( (reshape(H_uak(2,:,k),N_hor*N_ver,1).*a12*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal22 = sum( (reshape(H_uak(2,:,k),N_hor*N_ver,1).*a22*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal13 = sum( (reshape(H_uak(3,:,k),N_hor*N_ver,1).*a13*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal23 = sum( (reshape(H_uak(3,:,k),N_hor*N_ver,1).*a23*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal14 = sum( (reshape(H_uak(4,:,k),N_hor*N_ver,1).*a14*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal24 = sum( (reshape(H_uak(4,:,k),N_hor*N_ver,1).*a24*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal15 = sum( (reshape(H_uak(5,:,k),N_hor*N_ver,1).*a15*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal25 = sum( (reshape(H_uak(5,:,k),N_hor*N_ver,1).*a25*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal16 = sum( (reshape(H_uak(6,:,k),N_hor*N_ver,1).*a16*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal26 = sum( (reshape(H_uak(6,:,k),N_hor*N_ver,1).*a26*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal17 = sum( (reshape(H_uak(7,:,k),N_hor*N_ver,1).*a17*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal27 = sum( (reshape(H_uak(7,:,k),N_hor*N_ver,1).*a27*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal18 = sum( (reshape(H_uak(8,:,k),N_hor*N_ver,1).*a18*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal28 = sum( (reshape(H_uak(8,:,k),N_hor*N_ver,1).*a28*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal19 = sum( (reshape(H_uak(9,:,k),N_hor*N_ver,1).*a19*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal29 = sum( (reshape(H_uak(9,:,k),N_hor*N_ver,1).*a29*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal110 = sum( (reshape(H_uak(10,:,k),N_hor*N_ver,1).*a110*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal210 = sum( (reshape(H_uak(10,:,k),N_hor*N_ver,1).*a210*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal111 = sum( (reshape(H_uak(11,:,k),N_hor*N_ver,1).*a111*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal211 = sum( (reshape(H_uak(11,:,k),N_hor*N_ver,1).*a211*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal112 = sum( (reshape(H_uak(12,:,k),N_hor*N_ver,1).*a112*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal212 = sum( (reshape(H_uak(12,:,k),N_hor*N_ver,1).*a212*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    
    R_signal113 = sum( (reshape(H_uak(13,:,k),N_hor*N_ver,1).*a113*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal213 = sum( (reshape(H_uak(13,:,k),N_hor*N_ver,1).*a213*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal114 = sum( (reshape(H_uak(14,:,k),N_hor*N_ver,1).*a114*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal214 = sum( (reshape(H_uak(14,:,k),N_hor*N_ver,1).*a214*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal115 = sum( (reshape(H_uak(15,:,k),N_hor*N_ver,1).*a115*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal215 = sum( (reshape(H_uak(15,:,k),N_hor*N_ver,1).*a215*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal116 = sum( (reshape(H_uak(16,:,k),N_hor*N_ver,1).*a116*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal216 = sum( (reshape(H_uak(16,:,k),N_hor*N_ver,1).*a216*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal117 = sum( (reshape(H_uak(17,:,k),N_hor*N_ver,1).*a117*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal217 = sum( (reshape(H_uak(17,:,k),N_hor*N_ver,1).*a217*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal118 = sum( (reshape(H_uak(18,:,k),N_hor*N_ver,1).*a118*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal218 = sum( (reshape(H_uak(18,:,k),N_hor*N_ver,1).*a218*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal119 = sum( (reshape(H_uak(19,:,k),N_hor*N_ver,1).*a119*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal219 = sum( (reshape(H_uak(19,:,k),N_hor*N_ver,1).*a219*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal120 = sum( (reshape(H_uak(20,:,k),N_hor*N_ver,1).*a120*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal220 = sum( (reshape(H_uak(20,:,k),N_hor*N_ver,1).*a220*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal121 = sum( (reshape(H_uak(21,:,k),N_hor*N_ver,1).*a121*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal221 = sum( (reshape(H_uak(21,:,k),N_hor*N_ver,1).*a221*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal122 = sum( (reshape(H_uak(22,:,k),N_hor*N_ver,1).*a122*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal222 = sum( (reshape(H_uak(22,:,k),N_hor*N_ver,1).*a222*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal123 = sum( (reshape(H_uak(23,:,k),N_hor*N_ver,1).*a123*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal223 = sum( (reshape(H_uak(23,:,k),N_hor*N_ver,1).*a223*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal124 = sum( (reshape(H_uak(24,:,k),N_hor*N_ver,1).*a124*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal224 = sum( (reshape(H_uak(24,:,k),N_hor*N_ver,1).*a224*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    %}
    %{
    R_signal11 = sum( (reshape(H_1uak(1,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal21 = sum( (reshape(H_2uak(1,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal12 = sum( (reshape(H_1uak(2,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal22 = sum( (reshape(H_2uak(2,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal13 = sum( (reshape(H_1uak(3,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal23 = sum( (reshape(H_2uak(3,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal14 = sum( (reshape(H_1uak(4,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal24 = sum( (reshape(H_2uak(4,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal15 = sum( (reshape(H_1uak(5,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal25 = sum( (reshape(H_2uak(5,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal16 = sum( (reshape(H_1uak(6,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal26 = sum( (reshape(H_2uak(6,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal17 = sum( (reshape(H_1uak(7,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal27 = sum( (reshape(H_2uak(7,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal18 = sum( (reshape(H_1uak(8,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal28 = sum( (reshape(H_2uak(8,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal19 = sum( (reshape(H_1uak(9,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal29 = sum( (reshape(H_2uak(9,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal110 = sum( (reshape(H_1uak(10,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal210 = sum( (reshape(H_2uak(10,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal111 = sum( (reshape(H_1uak(11,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal211 = sum( (reshape(H_2uak(11,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal112 = sum( (reshape(H_1uak(12,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal212 = sum( (reshape(H_2uak(12,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    
    R_signal113 = sum( (reshape(H_1uak(13,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal213 = sum( (reshape(H_2uak(13,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal114 = sum( (reshape(H_1uak(14,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal214 = sum( (reshape(H_2uak(14,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal115 = sum( (reshape(H_1uak(15,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal215 = sum( (reshape(H_2uak(15,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal116 = sum( (reshape(H_1uak(16,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal216 = sum( (reshape(H_2uak(16,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal117 = sum( (reshape(H_1uak(17,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal217 = sum( (reshape(H_2uak(17,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal118 = sum( (reshape(H_1uak(18,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal218 = sum( (reshape(H_2uak(18,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal119 = sum( (reshape(H_1uak(19,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal219 = sum( (reshape(H_2uak(19,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal120 = sum( (reshape(H_1uak(20,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal220 = sum( (reshape(H_2uak(20,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal121 = sum( (reshape(H_1uak(21,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal221 = sum( (reshape(H_2uak(21,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal122 = sum( (reshape(H_1uak(22,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal222 = sum( (reshape(H_2uak(22,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal123 = sum( (reshape(H_1uak(23,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal223 = sum( (reshape(H_2uak(23,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal124 = sum( (reshape(H_1uak(24,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal224 = sum( (reshape(H_2uak(24,:,k),N_hor*N_ver,1)*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    %}

    %
    R_signal11 = sum( (reshape(H_1uak(1,:,k),N_hor*N_ver,1).*a11*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal21 = sum( (reshape(H_2uak(1,:,k),N_hor*N_ver,1).*a21*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal12 = sum( (reshape(H_1uak(2,:,k),N_hor*N_ver,1).*a12*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal22 = sum( (reshape(H_2uak(2,:,k),N_hor*N_ver,1).*a22*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal13 = sum( (reshape(H_1uak(3,:,k),N_hor*N_ver,1).*a13*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal23 = sum( (reshape(H_2uak(3,:,k),N_hor*N_ver,1).*a23*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal14 = sum( (reshape(H_1uak(4,:,k),N_hor*N_ver,1).*a14*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal24 = sum( (reshape(H_2uak(4,:,k),N_hor*N_ver,1).*a24*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal15 = sum( (reshape(H_1uak(5,:,k),N_hor*N_ver,1).*a15*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal25 = sum( (reshape(H_2uak(5,:,k),N_hor*N_ver,1).*a25*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal16 = sum( (reshape(H_1uak(6,:,k),N_hor*N_ver,1).*a16*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal26 = sum( (reshape(H_2uak(6,:,k),N_hor*N_ver,1).*a26*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal17 = sum( (reshape(H_1uak(7,:,k),N_hor*N_ver,1).*a17*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal27 = sum( (reshape(H_2uak(7,:,k),N_hor*N_ver,1).*a27*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal18 = sum( (reshape(H_1uak(8,:,k),N_hor*N_ver,1).*a18*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal28 = sum( (reshape(H_2uak(8,:,k),N_hor*N_ver,1).*a28*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal19 = sum( (reshape(H_1uak(9,:,k),N_hor*N_ver,1).*a19*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal29 = sum( (reshape(H_2uak(9,:,k),N_hor*N_ver,1).*a29*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal110 = sum( (reshape(H_1uak(10,:,k),N_hor*N_ver,1).*a110*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal210 = sum( (reshape(H_2uak(10,:,k),N_hor*N_ver,1).*a210*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    
    R_signal111 = sum( (reshape(H_1uak(11,:,k),N_hor*N_ver,1).*a111*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal211 = sum( (reshape(H_2uak(11,:,k),N_hor*N_ver,1).*a211*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal112 = sum( (reshape(H_1uak(12,:,k),N_hor*N_ver,1).*a112*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal212 = sum( (reshape(H_2uak(12,:,k),N_hor*N_ver,1).*a212*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal113 = sum( (reshape(H_1uak(13,:,k),N_hor*N_ver,1).*a113*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal213 = sum( (reshape(H_2uak(13,:,k),N_hor*N_ver,1).*a213*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal114 = sum( (reshape(H_1uak(14,:,k),N_hor*N_ver,1).*a114*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal214 = sum( (reshape(H_2uak(14,:,k),N_hor*N_ver,1).*a214*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal115 = sum( (reshape(H_1uak(15,:,k),N_hor*N_ver,1).*a115*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal215 = sum( (reshape(H_2uak(15,:,k),N_hor*N_ver,1).*a215*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal116 = sum( (reshape(H_1uak(16,:,k),N_hor*N_ver,1).*a116*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal216 = sum( (reshape(H_2uak(16,:,k),N_hor*N_ver,1).*a216*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal117 = sum( (reshape(H_1uak(17,:,k),N_hor*N_ver,1).*a117*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal217 = sum( (reshape(H_2uak(17,:,k),N_hor*N_ver,1).*a217*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal118 = sum( (reshape(H_1uak(18,:,k),N_hor*N_ver,1).*a118*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal218 = sum( (reshape(H_2uak(18,:,k),N_hor*N_ver,1).*a218*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal119 = sum( (reshape(H_1uak(19,:,k),N_hor*N_ver,1).*a119*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal219 = sum( (reshape(H_2uak(19,:,k),N_hor*N_ver,1).*a219*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal120 = sum( (reshape(H_1uak(20,:,k),N_hor*N_ver,1).*a120*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal220 = sum( (reshape(H_2uak(20,:,k),N_hor*N_ver,1).*a220*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    
    R_signal121 = sum( (reshape(H_1uak(21,:,k),N_hor*N_ver,1).*a121*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal221 = sum( (reshape(H_2uak(21,:,k),N_hor*N_ver,1).*a221*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal122 = sum( (reshape(H_1uak(22,:,k),N_hor*N_ver,1).*a122*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal222 = sum( (reshape(H_2uak(22,:,k),N_hor*N_ver,1).*a222*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal123 = sum( (reshape(H_1uak(23,:,k),N_hor*N_ver,1).*a123*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal223 = sum( (reshape(H_2uak(23,:,k),N_hor*N_ver,1).*a223*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal124 = sum( (reshape(H_1uak(24,:,k),N_hor*N_ver,1).*a124*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal224 = sum( (reshape(H_2uak(24,:,k),N_hor*N_ver,1).*a224*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal125 = sum( (reshape(H_1uak(25,:,k),N_hor*N_ver,1).*a125*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal225 = sum( (reshape(H_2uak(25,:,k),N_hor*N_ver,1).*a225*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal126 = sum( (reshape(H_1uak(26,:,k),N_hor*N_ver,1).*a126*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal226 = sum( (reshape(H_2uak(26,:,k),N_hor*N_ver,1).*a226*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal127 = sum( (reshape(H_1uak(27,:,k),N_hor*N_ver,1).*a127*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal227 = sum( (reshape(H_2uak(27,:,k),N_hor*N_ver,1).*a227*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal128 = sum( (reshape(H_1uak(28,:,k),N_hor*N_ver,1).*a128*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal228 = sum( (reshape(H_2uak(28,:,k),N_hor*N_ver,1).*a228*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal129 = sum( (reshape(H_1uak(29,:,k),N_hor*N_ver,1).*a129*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal229 = sum( (reshape(H_2uak(29,:,k),N_hor*N_ver,1).*a229*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal130 = sum( (reshape(H_1uak(30,:,k),N_hor*N_ver,1).*a130*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal230 = sum( (reshape(H_2uak(30,:,k),N_hor*N_ver,1).*a230*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    
    R_signal131 = sum( (reshape(H_1uak(31,:,k),N_hor*N_ver,1).*a131*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal231 = sum( (reshape(H_2uak(31,:,k),N_hor*N_ver,1).*a231*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal132 = sum( (reshape(H_1uak(32,:,k),N_hor*N_ver,1).*a132*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    R_signal232 = sum( (reshape(H_2uak(32,:,k),N_hor*N_ver,1).*a232*ones(1,N_beam)) .*W .*Amp_ak ,1 );
    %}
    
    P_tubk(1,1,:,k) = ( R_signal11.*conj(R_signal11) ) * 10^(-PL_dB_tu(1,1)/10);
    P_tubk(2,1,:,k) = ( R_signal21.*conj(R_signal21) ) * 10^(-PL_dB_tu(2,1)/10);
    P_tubk(1,2,:,k) = ( R_signal12.*conj(R_signal12) ) * 10^(-PL_dB_tu(1,2)/10);
    P_tubk(2,2,:,k) = ( R_signal22.*conj(R_signal22) ) * 10^(-PL_dB_tu(2,2)/10);
    P_tubk(1,3,:,k) = ( R_signal13.*conj(R_signal13) ) * 10^(-PL_dB_tu(1,3)/10);
    P_tubk(2,3,:,k) = ( R_signal23.*conj(R_signal23) ) * 10^(-PL_dB_tu(2,3)/10);
    P_tubk(1,4,:,k) = ( R_signal14.*conj(R_signal14) ) * 10^(-PL_dB_tu(1,4)/10);
    P_tubk(2,4,:,k) = ( R_signal24.*conj(R_signal24) ) * 10^(-PL_dB_tu(2,4)/10);
    P_tubk(1,5,:,k) = ( R_signal15.*conj(R_signal15) ) * 10^(-PL_dB_tu(1,5)/10);
    P_tubk(2,5,:,k) = ( R_signal25.*conj(R_signal25) ) * 10^(-PL_dB_tu(2,5)/10);
    P_tubk(1,6,:,k) = ( R_signal16.*conj(R_signal16) ) * 10^(-PL_dB_tu(1,6)/10);
    P_tubk(2,6,:,k) = ( R_signal26.*conj(R_signal26) ) * 10^(-PL_dB_tu(2,6)/10);
    P_tubk(1,7,:,k) = ( R_signal17.*conj(R_signal17) ) * 10^(-PL_dB_tu(1,7)/10);
    P_tubk(2,7,:,k) = ( R_signal27.*conj(R_signal27) ) * 10^(-PL_dB_tu(2,7)/10);
    P_tubk(1,8,:,k) = ( R_signal18.*conj(R_signal18) ) * 10^(-PL_dB_tu(1,8)/10);
    P_tubk(2,8,:,k) = ( R_signal28.*conj(R_signal28) ) * 10^(-PL_dB_tu(2,8)/10);
    P_tubk(1,9,:,k) = ( R_signal19.*conj(R_signal19) ) * 10^(-PL_dB_tu(1,9)/10);
    P_tubk(2,9,:,k) = ( R_signal29.*conj(R_signal29) ) * 10^(-PL_dB_tu(2,9)/10);
    P_tubk(1,10,:,k) = ( R_signal110.*conj(R_signal110) ) * 10^(-PL_dB_tu(1,10)/10);
    P_tubk(2,10,:,k) = ( R_signal210.*conj(R_signal210) ) * 10^(-PL_dB_tu(2,10)/10);
    
    P_tubk(1,11,:,k) = ( R_signal111.*conj(R_signal111) ) * 10^(-PL_dB_tu(1,11)/10);
    P_tubk(2,11,:,k) = ( R_signal211.*conj(R_signal211) ) * 10^(-PL_dB_tu(2,11)/10);
    P_tubk(1,12,:,k) = ( R_signal112.*conj(R_signal112) ) * 10^(-PL_dB_tu(1,12)/10);
    P_tubk(2,12,:,k) = ( R_signal212.*conj(R_signal212) ) * 10^(-PL_dB_tu(2,12)/10);
    P_tubk(1,13,:,k) = ( R_signal113.*conj(R_signal113) ) * 10^(-PL_dB_tu(1,13)/10);
    P_tubk(2,13,:,k) = ( R_signal213.*conj(R_signal213) ) * 10^(-PL_dB_tu(2,13)/10);
    P_tubk(1,14,:,k) = ( R_signal114.*conj(R_signal114) ) * 10^(-PL_dB_tu(1,14)/10);
    P_tubk(2,14,:,k) = ( R_signal214.*conj(R_signal214) ) * 10^(-PL_dB_tu(2,14)/10);
    P_tubk(1,15,:,k) = ( R_signal115.*conj(R_signal115) ) * 10^(-PL_dB_tu(1,15)/10);
    P_tubk(2,15,:,k) = ( R_signal215.*conj(R_signal215) ) * 10^(-PL_dB_tu(2,15)/10);
    P_tubk(1,16,:,k) = ( R_signal116.*conj(R_signal116) ) * 10^(-PL_dB_tu(1,16)/10);
    P_tubk(2,16,:,k) = ( R_signal216.*conj(R_signal216) ) * 10^(-PL_dB_tu(2,16)/10);
    P_tubk(1,17,:,k) = ( R_signal117.*conj(R_signal117) ) * 10^(-PL_dB_tu(1,17)/10);
    P_tubk(2,17,:,k) = ( R_signal217.*conj(R_signal217) ) * 10^(-PL_dB_tu(2,17)/10);
    P_tubk(1,18,:,k) = ( R_signal118.*conj(R_signal118) ) * 10^(-PL_dB_tu(1,18)/10);
    P_tubk(2,18,:,k) = ( R_signal218.*conj(R_signal218) ) * 10^(-PL_dB_tu(2,18)/10);
    P_tubk(1,19,:,k) = ( R_signal119.*conj(R_signal119) ) * 10^(-PL_dB_tu(1,19)/10);
    P_tubk(2,19,:,k) = ( R_signal219.*conj(R_signal219) ) * 10^(-PL_dB_tu(2,19)/10);
    P_tubk(1,20,:,k) = ( R_signal120.*conj(R_signal120) ) * 10^(-PL_dB_tu(1,20)/10);
    P_tubk(2,20,:,k) = ( R_signal220.*conj(R_signal220) ) * 10^(-PL_dB_tu(2,20)/10);
    
    P_tubk(1,21,:,k) = ( R_signal121.*conj(R_signal121) ) * 10^(-PL_dB_tu(1,21)/10);
    P_tubk(2,21,:,k) = ( R_signal221.*conj(R_signal221) ) * 10^(-PL_dB_tu(2,21)/10);
    P_tubk(1,22,:,k) = ( R_signal122.*conj(R_signal122) ) * 10^(-PL_dB_tu(1,22)/10);
    P_tubk(2,22,:,k) = ( R_signal222.*conj(R_signal222) ) * 10^(-PL_dB_tu(2,22)/10);
    P_tubk(1,23,:,k) = ( R_signal123.*conj(R_signal123) ) * 10^(-PL_dB_tu(1,23)/10);
    P_tubk(2,23,:,k) = ( R_signal223.*conj(R_signal223) ) * 10^(-PL_dB_tu(2,23)/10);
    P_tubk(1,24,:,k) = ( R_signal124.*conj(R_signal124) ) * 10^(-PL_dB_tu(1,24)/10);
    P_tubk(2,24,:,k) = ( R_signal224.*conj(R_signal224) ) * 10^(-PL_dB_tu(2,24)/10);
    P_tubk(1,25,:,k) = ( R_signal125.*conj(R_signal125) ) * 10^(-PL_dB_tu(1,25)/10);
    P_tubk(2,25,:,k) = ( R_signal225.*conj(R_signal225) ) * 10^(-PL_dB_tu(2,25)/10);
    P_tubk(1,26,:,k) = ( R_signal126.*conj(R_signal126) ) * 10^(-PL_dB_tu(1,26)/10);
    P_tubk(2,26,:,k) = ( R_signal226.*conj(R_signal226) ) * 10^(-PL_dB_tu(2,26)/10);
    P_tubk(1,27,:,k) = ( R_signal127.*conj(R_signal127) ) * 10^(-PL_dB_tu(1,27)/10);
    P_tubk(2,27,:,k) = ( R_signal227.*conj(R_signal227) ) * 10^(-PL_dB_tu(2,27)/10);
    P_tubk(1,28,:,k) = ( R_signal128.*conj(R_signal128) ) * 10^(-PL_dB_tu(1,28)/10);
    P_tubk(2,28,:,k) = ( R_signal228.*conj(R_signal228) ) * 10^(-PL_dB_tu(2,28)/10);
    P_tubk(1,29,:,k) = ( R_signal129.*conj(R_signal129) ) * 10^(-PL_dB_tu(1,29)/10);
    P_tubk(2,29,:,k) = ( R_signal229.*conj(R_signal229) ) * 10^(-PL_dB_tu(2,29)/10);
    P_tubk(1,30,:,k) = ( R_signal130.*conj(R_signal130) ) * 10^(-PL_dB_tu(1,30)/10);
    P_tubk(2,30,:,k) = ( R_signal230.*conj(R_signal230) ) * 10^(-PL_dB_tu(2,30)/10);
    
    P_tubk(1,31,:,k) = ( R_signal131.*conj(R_signal131) ) * 10^(-PL_dB_tu(1,31)/10);
    P_tubk(2,31,:,k) = ( R_signal231.*conj(R_signal231) ) * 10^(-PL_dB_tu(2,31)/10);
    P_tubk(1,32,:,k) = ( R_signal132.*conj(R_signal132) ) * 10^(-PL_dB_tu(1,32)/10);
    P_tubk(2,32,:,k) = ( R_signal232.*conj(R_signal232) ) * 10^(-PL_dB_tu(2,32)/10);
    
    % ユーザu, サブキャリアkのときの, 各ビームパターンでの受信信号電力
    
    b(1,k) = find( P_tubk(1,1,:,k) == max(P_tubk(1,1,:,k)) ,1 );
    b(2,k) = find( P_tubk(1,2,:,k) == max(P_tubk(1,2,:,k)) ,1 );
    b(3,k) = find( P_tubk(1,3,:,k) == max(P_tubk(1,3,:,k)) ,1 );
    b(4,k) = find( P_tubk(1,4,:,k) == max(P_tubk(1,4,:,k)) ,1 );
    b(5,k) = find( P_tubk(1,5,:,k) == max(P_tubk(1,5,:,k)) ,1 );
    b(6,k) = find( P_tubk(1,6,:,k) == max(P_tubk(1,6,:,k)) ,1 );
    b(7,k) = find( P_tubk(1,7,:,k) == max(P_tubk(1,7,:,k)) ,1 );
    b(8,k) = find( P_tubk(1,8,:,k) == max(P_tubk(1,8,:,k)) ,1 );
    b(9,k) = find( P_tubk(1,9,:,k) == max(P_tubk(1,9,:,k)) ,1 );
    b(10,k) = find( P_tubk(1,10,:,k) == max(P_tubk(1,10,:,k)) ,1 );
    b(11,k) = find( P_tubk(1,11,:,k) == max(P_tubk(1,11,:,k)) ,1 );
    b(12,k) = find( P_tubk(1,12,:,k) == max(P_tubk(1,12,:,k)) ,1 );
    b(13,k) = find( P_tubk(1,13,:,k) == max(P_tubk(1,13,:,k)) ,1 );
    b(14,k) = find( P_tubk(1,14,:,k) == max(P_tubk(1,14,:,k)) ,1 );
    b(15,k) = find( P_tubk(1,15,:,k) == max(P_tubk(1,15,:,k)) ,1 );
    b(16,k) = find( P_tubk(1,16,:,k) == max(P_tubk(1,16,:,k)) ,1 );
    
    b(17,k) = find( P_tubk(2,17,:,k) == max(P_tubk(2,17,:,k)) ,1 );
    b(18,k) = find( P_tubk(2,18,:,k) == max(P_tubk(2,18,:,k)) ,1 );
    b(19,k) = find( P_tubk(2,19,:,k) == max(P_tubk(2,19,:,k)) ,1 );
    b(20,k) = find( P_tubk(2,20,:,k) == max(P_tubk(2,20,:,k)) ,1 );
    b(21,k) = find( P_tubk(2,21,:,k) == max(P_tubk(2,21,:,k)) ,1 );
    b(22,k) = find( P_tubk(2,22,:,k) == max(P_tubk(2,22,:,k)) ,1 );
    b(23,k) = find( P_tubk(2,23,:,k) == max(P_tubk(2,23,:,k)) ,1 );
    b(24,k) = find( P_tubk(2,24,:,k) == max(P_tubk(2,24,:,k)) ,1 );
    b(25,k) = find( P_tubk(1,25,:,k) == max(P_tubk(1,25,:,k)) ,1 );
    b(26,k) = find( P_tubk(1,26,:,k) == max(P_tubk(1,26,:,k)) ,1 );
    b(27,k) = find( P_tubk(2,27,:,k) == max(P_tubk(2,27,:,k)) ,1 );
    b(28,k) = find( P_tubk(2,28,:,k) == max(P_tubk(2,28,:,k)) ,1 );
    b(29,k) = find( P_tubk(2,29,:,k) == max(P_tubk(2,29,:,k)) ,1 );
    b(30,k) = find( P_tubk(2,30,:,k) == max(P_tubk(2,30,:,k)) ,1 );
    b(31,k) = find( P_tubk(2,31,:,k) == max(P_tubk(2,31,:,k)) ,1 );
    b(32,k) = find( P_tubk(2,32,:,k) == max(P_tubk(2,32,:,k)) ,1 );
    
for u1 = 1:Na_1TP
    for u2 = 1:Na_1TP
        power_uuk1(u1,u2,k) = P_tubk(1,u1,b(u2,k),k);
        power_uuk_all(u1,u2,k) = P_tubk(1,u1,b(u2,k),k);
    end
end

for u1 = 1:Na_1TP
    for u2 = 1:Na_1TP
        power_uuk2(u1,u2,k) = P_tubk(2,u1+Nu_1TP,b(u2+Nu_1TP,k),k);
        power_uuk_all(u1+Nu_1TP,u2+Nu_1TP,k) = P_tubk(2,u1+Nu_1TP,b(u2+Nu_1TP,k),k);
    end
end

for u1 = 1:Na_1TP
    for u2 = 1:Na_1TP
        power_uuk_all(u1,u2+Nu_1TP,k) = P_tubk(2,u1,b(u2+Nu_1TP,k),k);
        power_uuk_all(u2+Nu_1TP,u1,k) = P_tubk(1,u2+Nu_1TP,b(u1,k),k);
    end
end

%%

T11_signal075 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(7.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_075 = (  T11_signal075.*conj(T11_signal075) ) * 10^(-PL_dB_tu(1,1)/10);
    
T11_signal225 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(22.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_225 = (  T11_signal225.*conj(T11_signal225) ) * 10^(-PL_dB_tu(1,2)/10);
    
T11_signal375 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(37.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_375 = (  T11_signal375.*conj(T11_signal375) ) * 10^(-PL_dB_tu(1,3)/10);
    
T11_signal525 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(52.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_525 = (  T11_signal525.*conj(T11_signal525) ) * 10^(-PL_dB_tu(1,4)/10);
    
T11_signal675 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(67.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_675 = (  T11_signal675.*conj(T11_signal675) ) * 10^(-PL_dB_tu(1,5)/10);
    
T11_signal825 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(82.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_825 = (  T11_signal825.*conj(T11_signal825) ) * 10^(-PL_dB_tu(1,6)/10);
    
T11_signal975 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(97.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_975 = (  T11_signal975.*conj(T11_signal975) ) * 10^(-PL_dB_tu(1,7)/10);
    
T11_signal1125 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(112.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_1125 = (  T11_signal1125.*conj(T11_signal1125) ) * 10^(-PL_dB_tu(1,8)/10);
    
T11_signal1275 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(127.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_1275 = (  T11_signal1275.*conj(T11_signal1275) ) * 10^(-PL_dB_tu(1,9)/10);
    
T11_signal1425 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(142.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_1425 = (  T11_signal1425.*conj(T11_signal1425) ) * 10^(-PL_dB_tu(1,10)/10);
    
T11_signal1575 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(157.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_1575 = (  T11_signal1575.*conj(T11_signal1575) ) * 10^(-PL_dB_tu(1,11)/10);
    
T11_signal1725 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(172.5/d_hor))*ones(1,N_beam)) .*A11 .*Amp_ak ,1 );
    P11_1725 = (  T11_signal1725.*conj(T11_signal1725) ) * 10^(-PL_dB_tu(1,12)/10);

    
    
T21_signal075 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(7.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_075 = (  T21_signal075.*conj(T21_signal075) ) .* PL_t21;
    
T21_signal225 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(22.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_225 = (  T21_signal225.*conj(T21_signal225) ) .* PL_t21;
    
T21_signal375 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(37.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_375 = (  T21_signal375.*conj(T21_signal375) ) .* PL_t21;
    
T21_signal525 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(52.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_525 = (  T21_signal525.*conj(T21_signal525) ) .* PL_t21;
    
T21_signal675 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(67.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_675 = (  T21_signal675.*conj(T21_signal675) ) .* PL_t21;
    
T21_signal825 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(82.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_825 = (  T21_signal825.*conj(T21_signal825) ) .* PL_t21;
    
T21_signal975 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(97.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_975 = (  T21_signal975.*conj(T21_signal975) ) .* PL_t21;
    
T21_signal1125 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(112.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_1125 = (  T21_signal1125.*conj(T21_signal1125) ) .* PL_t21;
    
T21_signal1275 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(127.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_1275 = (  T21_signal1275.*conj(T21_signal1275) ) .* PL_t21;
    
T21_signal1425 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(142.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_1425 = (  T21_signal1425.*conj(T21_signal1425) ) .* PL_t21;
    
T21_signal1575 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(157.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_1575 = (  T21_signal1575.*conj(T21_signal1575) ) .* PL_t21;
    
T21_signal1725 = sum( (reshape(H_uak(1,:,k),N_hor*N_ver,1).*W(:,round(172.5/d_hor))*ones(1,N_beam)) .*A21 .*Amp_ak ,1 );
    P21_1725 = (  T21_signal1725.*conj(T21_signal1725) ) .* PL_t21;
    
    P11_075 = P11_075/max(P11_075);
    P11_225 = P11_225/max(P11_225);
    P11_375 = P11_375/max(P11_375);
    P11_525 = P11_525/max(P11_525);
    P11_675 = P11_675/max(P11_675);
    P11_825 = P11_825/max(P11_825);
    P11_975 = P11_975/max(P11_975);
    P11_1125 = P11_1125/max(P11_1125);
    P11_1275 = P11_1275/max(P11_1275);
    P11_1425 = P11_1425/max(P11_1425);
    P11_1575 = P11_1575/max(P11_1575);
    P11_1725 = P11_1725/max(P11_1725);
    
    P21_075 = P21_075/max(P11_075);
    P21_225 = P21_225/max(P11_225);
    P21_375 = P21_375/max(P11_375);
    P21_525 = P21_525/max(P11_525);
    P21_675 = P21_675/max(P11_675);
    P21_825 = P21_825/max(P11_825);
    P21_975 = P21_975/max(P11_975);
    P21_1125 = P21_1125/max(P11_1125);
    P21_1275 = P21_1275/max(P11_1275);
    P21_1425 = P21_1425/max(P11_1425);
    P21_1575 = P21_1575/max(P11_1575);
    P21_1725 = P21_1725/max(P11_1725);
    
end   % サブキャリアごとの値格納終了


%%
for c12 = 1:length(UC12)
    throughput_UC12(c12) = log2( 1 + power_uuk_all(UC12(c12,1),UC12(c12,1),1)/(power_uuk_all(UC12(c12,1),UC12(c12,2),1) + Npw) )...
        + log2( 1 + power_uuk_all(UC12(c12,2),UC12(c12,2),1)/(power_uuk_all(UC12(c12,2),UC12(c12,1),1) + Npw) );
end

[throughput_ranking,ranking_index] = sort(throughput_UC12,'descend')
UC12(ranking_index,:)


%%
Rx_power_directivity11 = zeros(Nu_1TP,N_beam);
Rx_power_directivity21 = zeros(Nu_1TP,N_beam);
Rx_power_directivity12 = zeros(Nu_1TP,N_beam);

for u = 1:Na_1TP
    Rx_power_directivity11(u,:) = P_tubk(1,u,:,1);
    Rx_power_directivity21(u,:) = P_tubk(2,u,:,1);
    Rx_power_directivity12(u,:) = P_tubk(1,u+Na_1TP,:,1);

    Rx_power_directivity11(u,:) = Rx_power_directivity11(u,:)/max(Rx_power_directivity11(u,:));
    Rx_power_directivity21(u,:) = Rx_power_directivity21(u,:)/max(Rx_power_directivity11(u,:));
    Rx_power_directivity12(u,:) = Rx_power_directivity12(u,:)/max(Rx_power_directivity11(u,:));
end

Rx_power_directivity11_dB = 10*log10(Rx_power_directivity11);
Rx_power_directivity21_dB = 10*log10(Rx_power_directivity21);
Rx_power_directivity12_dB = 10*log10(Rx_power_directivity12);

%
save(['CDL_channel_TP1/CDL_channel_matrix.mat'] ,'H_1uak' )
save(['CDL_channel_TP2/CDL_channel_matrix.mat'] ,'H_2uak' )
%}

%% figure

Power_u2u = power_uuk_all(:,:,1);
Power_u2u = Power_u2u./max(Power_u2u);

figure
mesh(1:Nu_all,1:Nu_all,Power_u2u)
xlabel('受信側のユーザ','FontSize',20,'FontName','Arial')
ylabel('ビームを向けるユーザ','FontSize',20,'FontName','Arial')
zlabel('ビーム電力パターン','FontSize',20,'FontName','Arial')

figure
mesh(1:Nu_all,1:Nu_all,10*log10(Power_u2u))
xlabel('受信側のユーザ','FontSize',20,'FontName','Arial')
ylabel('ビームを向けるユーザ','FontSize',20,'FontName','Arial')
zlabel('ビーム電力パターン','FontSize',20,'FontName','Arial')


%% ユーザかビーム固定
figure
plot(anglerange_hor, Rx_power_directivity11_dB(1,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(1,:))
legend({'基地局１から見て方位角7.5度に位置するユーザ','基地局２から見て方位角7.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ビーム電力パターン','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor, Rx_power_directivity21_dB(1,:))
legend({'基地局１から見て方位角7.5度に位置するユーザ'},'Location','southeast','FontSize',6)
xlabel('基地局２から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')

figure
plot(anglerange_hor, Rx_power_directivity12_dB(1,:))
legend({'基地局２から見て方位角7.5度に位置するユーザ'},'Location','southeast','FontSize',6)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}
figure
plot(anglerange_hor,10*log10(P11_075))
hold on
plot(anglerange_hor,10*log10(P21_075))
legend({'基地局１から送信するビームの方位角7.5度','基地局２から送信するビームの方位角7.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor,10*log10(P21_075))
legend({'基地局２から送信するビームの方位角7.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}



figure
plot(anglerange_hor, Rx_power_directivity11_dB(2,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(2,:))
legend({'基地局１から見て方位角22.5度に位置するユーザ','基地局２から見て方位角22.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor, Rx_power_directivity21_dB(2,:))
legend({'基地局１から見て方位角22.5度に位置するユーザ'},'Location','southeast','FontSize',6)
xlabel('基地局２から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}
figure
plot(anglerange_hor,10*log10(P11_225))
hold on
plot(anglerange_hor,10*log10(P21_225))
legend({'基地局１から送信するビームの方位角22.5度','基地局２から送信するビームの方位角22.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor,10*log10(P21_225))
legend({'基地局２から送信するビームの方位角22.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}




figure
plot(anglerange_hor, Rx_power_directivity11_dB(3,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(3,:))
legend({'基地局１から見て方位角37.5度に位置するユーザ','基地局２から見て方位角37.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor, Rx_power_directivity21_dB(3,:))
legend({'基地局１から見て方位角37.5度に位置するユーザ'},'Location','southeast','FontSize',6)
xlabel('基地局２から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}
figure
plot(anglerange_hor,10*log10(P11_375))
hold on
plot(anglerange_hor,10*log10(P21_375))
legend({'基地局１から送信するビームの方位角37.5度','基地局２から送信するビームの方位角37.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor,10*log10(P21_375))
legend({'基地局２から送信するビームの方位角37.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}




figure
plot(anglerange_hor, Rx_power_directivity11_dB(4,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(4,:))
legend({'基地局１から見て方位角52.5度に位置するユーザ','基地局２から見て方位角52.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor, Rx_power_directivity21_dB(4,:))
legend({'基地局１から見て方位角52.5度に位置するユーザ'},'Location','southeast','FontSize',6)
xlabel('基地局２から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}
figure
plot(anglerange_hor,10*log10(P11_525))
hold on
plot(anglerange_hor,10*log10(P21_525))
legend({'基地局１から送信するビームの方位角52.5度','基地局２から送信するビームの方位角52.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor,10*log10(P21_525))
legend({'基地局２から送信するビームの方位角52.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}




figure
plot(anglerange_hor, Rx_power_directivity11_dB(5,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(5,:))
legend({'基地局１から見て方位角67.5度に位置するユーザ','基地局２から見て方位角67.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor, Rx_power_directivity21_dB(5,:))
legend({'基地局１から見て方位角67.5度に位置するユーザ'},'Location','southeast','FontSize',6)
xlabel('基地局２から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}
figure
plot(anglerange_hor,10*log10(P11_675))
hold on
plot(anglerange_hor,10*log10(P21_675))
legend({'基地局１から送信するビームの方位角67.5度','基地局２から送信するビームの方位角67.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor,10*log10(P21_675))
legend({'基地局２から送信するビームの方位角67.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}




figure
plot(anglerange_hor, Rx_power_directivity11_dB(6,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(6,:))
legend({'基地局１から見て方位角82.5度に位置するユーザ','基地局２から見て方位角82.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor, Rx_power_directivity21_dB(6,:))
legend({'基地局１から見て方位角82.5度に位置するユーザ'},'Location','southeast','FontSize',6)
xlabel('基地局２から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}
figure
plot(anglerange_hor,10*log10(P11_825))
hold on
plot(anglerange_hor,10*log10(P21_825))
legend({'基地局１から送信するビームの方位角82.5度','基地局２から送信するビームの方位角82.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%{
figure
plot(anglerange_hor,10*log10(P21_825))
legend({'基地局２から送信するビームの方位角82.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')
%}




%%
figure
plot(anglerange_hor, Rx_power_directivity11_dB(7,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(7,:))
legend({'基地局１から見て方位角97.5度に位置するユーザ','基地局２から見て方位角97.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')

figure
plot(anglerange_hor,10*log10(P11_975))
hold on
plot(anglerange_hor,10*log10(P21_975))
legend({'基地局１から送信するビームの方位角97.5度','基地局２から送信するビームの方位角97.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')


figure
plot(anglerange_hor, Rx_power_directivity11_dB(8,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(8,:))
legend({'基地局１から見て方位角112.5度に位置するユーザ','基地局２から見て方位角112.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')

figure
plot(anglerange_hor,10*log10(P11_1125))
hold on
plot(anglerange_hor,10*log10(P21_1125))
legend({'基地局１から送信するビームの方位角112.5度','基地局２から送信するビームの方位角112.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')


figure
plot(anglerange_hor, Rx_power_directivity11_dB(9,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(9,:))
legend({'基地局１から見て方位角127.5度に位置するユーザ','基地局２から見て方位角127.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')

figure
plot(anglerange_hor,10*log10(P11_1275))
hold on
plot(anglerange_hor,10*log10(P21_1275))
legend({'基地局１から送信するビームの方位角127.5度','基地局２から送信するビームの方位角127.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')


figure
plot(anglerange_hor, Rx_power_directivity11_dB(10,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(10,:))
legend({'基地局１から見て方位角142.5度に位置するユーザ','基地局２から見て方位角142.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')

figure
plot(anglerange_hor,10*log10(P11_1425))
hold on
plot(anglerange_hor,10*log10(P21_1425))
legend({'基地局１から送信するビームの方位角142.5度','基地局２から送信するビームの方位角142.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')



figure
plot(anglerange_hor, Rx_power_directivity11_dB(11,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(11,:))
legend({'基地局１から見て方位角157.5度に位置するユーザ','基地局２から見て方位角157.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')

figure
plot(anglerange_hor,10*log10(P11_1575))
hold on
plot(anglerange_hor,10*log10(P21_1575))
legend({'基地局１から送信するビームの方位角157.5度','基地局２から送信するビームの方位角157.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')


figure
plot(anglerange_hor, Rx_power_directivity11_dB(12,:))
hold on
plot(anglerange_hor, Rx_power_directivity12_dB(12,:))
legend({'基地局１から見て方位角172.5度に位置するユーザ','基地局２から見て方位角172.5度に位置するユーザ'},'Location','southeast','FontSize',12)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')

figure
plot(anglerange_hor,10*log10(P11_1725))
hold on
plot(anglerange_hor,10*log10(P21_1725))
legend({'基地局１から送信するビームの方位角172.5度','基地局２から送信するビームの方位角172.5度'},'Location','southeast','FontSize',12)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('ユーザの受信電力','FontSize',20,'FontName','Arial')


%%
%{
figure
for u = 1:Na_TP
plot(anglerange_hor, Rx_power_directivity11_dB(u,:))
hold on
end
legend({'基地局１から見て方位角7.5度に位置するユーザ','22.5度','37.5度','52.5度','67.5度','82.5度','97.5度'...
    ,'112.5度','127.5度','142.5度','157.5度','172.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('各ユーザの受信電力(dBm)','FontSize',20,'FontName','Arial')


figure
for u = 1:Na_TP
plot(anglerange_hor, Rx_power_directivity21_dB(u,:))
hold on
end
legend({'基地局１から見て方位角7.5度に位置するユーザ','22.5度','37.5度','52.5度','67.5度','82.5度','97.5度'...
    ,'112.5度','127.5度','142.5度','157.5度','172.5度'},'Location','southeast','FontSize',6)
xlabel('基地局２から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('各ユーザの受信電力(dBm)','FontSize',20,'FontName','Arial')


figure
for u = 1:Na_TP
plot(anglerange_hor, Rx_power_directivity12_dB(u,:))
hold on
end
legend({'基地局２から見て方位角7.5度に位置するユーザ','22.5度','37.5度','52.5度','67.5度','82.5度','97.5度'...
    ,'112.5度','127.5度','142.5度','157.5度','172.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から送信するビームの方位角','FontSize',20,'FontName','Arial')
ylabel('各ユーザの受信電力(dBm)','FontSize',20,'FontName','Arial')


figure
plot(anglerange_hor,10*log10(P11_075))
hold on
plot(anglerange_hor,10*log10(P11_225))
hold on
plot(anglerange_hor,10*log10(P11_375))
hold on
plot(anglerange_hor,10*log10(P11_525))
hold on
plot(anglerange_hor,10*log10(P11_675))
hold on
plot(anglerange_hor,10*log10(P11_825))
hold on
plot(anglerange_hor,10*log10(P11_975))
hold on
plot(anglerange_hor,10*log10(P11_1125))
hold on
plot(anglerange_hor,10*log10(P11_1275))
hold on
plot(anglerange_hor,10*log10(P11_1425))
hold on
plot(anglerange_hor,10*log10(P11_1575))
hold on
plot(anglerange_hor,10*log10(P11_1725))
hold on
legend({'基地局１から送信するビームの方位角7.5度','22.5度','37.5度','52.5度','67.5度','82.5度','97.5度'...
    ,'112.5度','127.5度','142.5度','157.5度','172.5度'},'Location','southeast','FontSize',6)
ylabel('各ユーザの受信電力(dBm)','FontSize',20,'FontName','Arial')


figure
plot(anglerange_hor,10*log10(P21_075))
hold on
plot(anglerange_hor,10*log10(P21_225))
hold on
plot(anglerange_hor,10*log10(P21_375))
hold on
plot(anglerange_hor,10*log10(P21_525))
hold on
plot(anglerange_hor,10*log10(P21_675))
hold on
plot(anglerange_hor,10*log10(P21_825))
hold on
plot(anglerange_hor,10*log10(P21_975))
hold on
plot(anglerange_hor,10*log10(P21_1125))
hold on
plot(anglerange_hor,10*log10(P21_1275))
hold on
plot(anglerange_hor,10*log10(P21_1425))
hold on
plot(anglerange_hor,10*log10(P21_1575))
hold on
plot(anglerange_hor,10*log10(P21_1725))
hold on
legend({'基地局１から送信するビームの方位角7.5度','22.5度','37.5度','52.5度','67.5度','82.5度','97.5度'...
    ,'112.5度','127.5度','142.5度','157.5度','172.5度'},'Location','southeast','FontSize',6)
xlabel('基地局１から見たユーザの方位角','FontSize',20,'FontName','Arial')
ylabel('各ユーザの受信電力(dBm)','FontSize',20,'FontName','Arial')
%}