%% ワークスペース, コマンドウィンドウ, 乱数の初期化
clear
clc
rng('shuffle');

%% パラメータ設定
c = 3e8;                   % 光速
fc = 5.2e9;                % 中心周波数
lambda = c/fc;             % 波長λ
d_antenna = lambda/2;      % 隣接する素子間距離
N_ver = 8;                 % 垂直方向の素子数
N_hor = 16;                % 水平方向の素子数

N_subcar = 288;
N_RB = 24;
N_subcar_1RB = N_subcar/N_RB;

d_subcar = 120e3;                               % サブキャリア間隔, 120 kHz
bandwidth = d_subcar * N_subcar;                % 帯域幅が大きければ大きいほど雑音電力が大きくなる
bandwidth_dB = 10*log10(bandwidth);
f_range = fc-(bandwidth/2)+d_subcar/2 : d_subcar : fc+(bandwidth/2)-d_subcar/2;
noise_1Hz_dBm = -174;                           % 単位帯域幅 1Hzあたりの雑音電力
Noise_Figure_dB = 9;
noise_variance_dBm = noise_1Hz_dBm + bandwidth_dB + Noise_Figure_dB;
Npw = 10^(noise_variance_dBm/10);               % ノイズの電力(mW)
Tx_1element_mW = 1000/(N_ver*N_hor);            % 各素子当たり何mWなのか 振幅は1/√アンテナ素子数
Tx_1element_dBm = 10*log10(Tx_1element_mW);     % dBmで表示
SN_dB_1element = Tx_1element_dBm - noise_variance_dBm;
Desire_power_dBm = Tx_1element_dBm + 10*log10((N_ver*N_hor)^2);
% SNRの値を計算 雑音の電力は-174dBを利用して計算
SN_dB = Desire_power_dBm - noise_variance_dBm;
SN_ratio = 10^(SN_dB/10);

N_TP = 2;
Nu_1RB = 1;
Nu_TP1 = 12;
Nu_TP2 = 12;
Nu_all = Nu_TP1+Nu_TP2;
N_area = 16;
N_area_1TP = N_area/2;
%hor_1area = 180/(N_area/2);
area_boundary = [0,atand(4/N_area_1TP),45,90-atand(4/N_area_1TP),90,90+atand(4/N_area_1TP),135,180-atand(4/N_area_1TP),180];

% 振幅を設定( mW ) 総アンテナ数×サブキャリア数
Amp_ak = ones(N_hor*N_ver,N_subcar)*sqrt( (10^(Tx_1element_dBm/10))/Nu_1RB );

%{
% 伝搬ロスの係数, 距離のple乗に比例して減衰する UMa cellモデル
ple_LOS = 2.20;
ple_NLOS = 3.67;
d_LOS = 36;
%}

%
d_TP = 200;
d_edge = d_TP/2;
h_BS = 10;
h_UT = 1.5;

carf = ones(N_RB,1) * [1 10 19 28 37 46 55 64 2 11 20 29 38 47 56 57 3 12 21 30 39 48 49 58 4 13 22 31 40 41 50 59 5 14 23 32 33 42 51 60 6 15 24 25 34 43 52 61 7 16 17 26 35 44 53 62 8 9 18 27 36 45 54 63];
carf = repmat(carf,1,8);

N_timeslot = length(carf)*7;
N_subframe = N_timeslot/7;
%}

N_trial = 10000;



%% 仰角と方位角の範囲を決める
N_beam = N_subcar;                       % 基地局で用意しておくDBFのビーム数
d_hor = 180/N_beam;                      % 仰角,方位角の刻み間隔,これがビームの本数を決める
anglerange_hor = d_hor:d_hor:180;        % 水平方向の角度の下限から上限
hor_index = anglerange_hor/d_hor;        % 水平方向のインデックス

%% 基地局側でビームフォーミング重み行列を生成する
% ビームを向ける角度,ビームを向ける方向,仰角方位角を変化させていく
W = zeros(N_ver*N_hor,N_beam);

for bh = hor_index
        W(:,bh) = w_BF_128_1(bh*d_hor,90);
end              % bh番目のビームパターンの重みをbh列目に代入する

%% 値を格納する箱を用意

power_uuk1 = zeros(Nu_TP1,Nu_TP1,N_subcar);
power_uuk2 = zeros(Nu_TP2,Nu_TP2,N_subcar);

power_uuk_all = zeros(Nu_all,Nu_all,N_subcar);

UC1 = combnk(1:Nu_TP1,Nu_1RB);
UC2 = combnk(Nu_TP1+1:Nu_all,Nu_1RB);

AC1 = combnk(1:N_area_1TP,Nu_1RB);
AC2 = combnk(N_area_1TP+1:N_area,Nu_1RB);
AC12 = zeros(length(AC1)*length(AC2), Nu_1RB*2);

for c1 = 1:length(AC1)
    for c2 = 1:length(AC2)
        AC12((c1-1)*length(AC2)+c2,:) = horzcat( AC1(c1,:),AC2(c2,:) );
    end
end

PL_dB_tu = zeros(N_TP,Nu_all);

H_uak = ones(Nu_all,N_hor*N_ver,N_subcar);
%
load(['CDL_channel_TP1/CDL_channel_matrix.mat'] ,'H_1uak' )
load(['CDL_channel_TP2/CDL_channel_matrix.mat'] ,'H_2uak' )
%{
H_1uak = ones(Nu_all,N_hor*N_ver,N_subcar);
H_2uak = ones(Nu_all,N_hor*N_ver,N_subcar);
%}
b = zeros(Nu_all,N_subcar);

P_tul = zeros(N_TP,Nu_all,N_beam);

cumulative_throughput_ut = zeros(Nu_all,N_trial);
cumulative_throughput_utc = zeros(Nu_all,N_trial);
cumulative_throughput_utp = zeros(Nu_all,N_trial);

cumulative_throughput_at = zeros(N_area,N_trial);
cumulative_throughput_atc = zeros(N_area,N_trial);
cumulative_throughput_atp = zeros(N_area,N_trial);

cumulative_throughput_ut_I0 = zeros(Nu_all,N_trial);
cumulative_throughput_utc_I0 = zeros(Nu_all,N_trial);
cumulative_throughput_utp_I0 = zeros(Nu_all,N_trial);

cumulative_throughput_at_I0 = zeros(N_area,N_trial);
cumulative_throughput_atc_I0 = zeros(N_area,N_trial);
cumulative_throughput_atp_I0 = zeros(N_area,N_trial);

N_aut = zeros(N_area,N_trial);

total_comb = 0;
total_comb_con = 0;
total_comb_pro = 0;





%% 各試行回数ごとにランダムな環境
for trial = 1:N_trial
%% 試行ごとに値が変わる変数の箱の初期化

d_tu = zeros(N_TP,Nu_all);
hor_tu = zeros(N_TP,Nu_all);
area_user = zeros(N_area,max(Nu_TP1,Nu_TP2));
u2a = zeros(1,Nu_all);
nua = zeros(1,Nu_all);
mua1 = zeros(1,Nu_TP1);
mua2 = zeros(1,Nu_TP2);
count_nua = 0;
count_mua1 = 0;
count_mua2 = 0;

a2aps = zeros(N_area,N_area);
a2apsc = zeros(N_area,N_area);
a2apsp = zeros(N_area,N_area);

%%
%{
if 0.5 < rand

for u = 1:Nu_TP1
    dx = -1*d_edge+2*d_edge*rand;
    dy = d_edge*rand;
    %dy = (d_edge-0.0001)*rand+0.0001;
    d_tu(1,u) = sqrt(dx^2+dy^2);
    hor_tu(1,u) = acosd(dx/d_tu(1,u));
    d_tu(2,u) = sqrt( d_tu(1,u)^2 + d_TP^2 - 2*d_tu(1,u)*d_TP*cosd(180-hor_tu(1,u)) );
    hor_tu(2,u) = asind( d_tu(1,u)*sind(180-hor_tu(1,u))/d_tu(2,u) );
end

for u = Nu_TP1+1:Nu_all
    dx = -1*d_edge+2*d_edge*rand;
    dy = d_edge*rand;
    %dy = (d_edge-0.0001)*rand+0.0001;
    d_tu(2,u) = sqrt(dx^2+dy^2);
    hor_tu(2,u) = acosd(dx/d_tu(2,u));
    d_tu(1,u) = sqrt( d_tu(2,u)^2 + d_TP^2 - 2*d_tu(2,u)*d_TP*cosd(hor_tu(2,u)) );
    hor_tu(1,u) = 180 - asind( d_tu(2,u)*sind(hor_tu(2,u))/d_tu(1,u) );
end

else
%}

for u = 1:Nu_TP1
    hor_tu(1,u) = 180*rand;
    if (hor_tu(1,u) <= 45) || (135 <= hor_tu(1,u))
        d_tu(1,u) = d_edge*rand/abs(cosd(hor_tu(1,u)));
    else
        d_tu(1,u) = d_edge*rand/abs(cosd(90-hor_tu(1,u)));
    end
    
    d_tu(2,u) = sqrt( d_tu(1,u)^2 + d_TP^2 - 2*d_tu(1,u)*d_TP*cosd(180-hor_tu(1,u)) );
    hor_tu(2,u) = asind( d_tu(1,u)*sind(180-hor_tu(1,u))/d_tu(2,u) );
end

for u = Nu_TP1+1:Nu_all
    hor_tu(2,u) = 180*rand;
    if (hor_tu(2,u) <= 45) || (135 <= hor_tu(2,u))
        d_tu(2,u) = d_edge*rand/abs(cosd(hor_tu(2,u)));
    else
        d_tu(2,u) = d_edge*rand/abs(cosd(90-hor_tu(2,u)));
    end
    
    d_tu(1,u) = sqrt( d_tu(2,u)^2 + d_TP^2 - 2*d_tu(2,u)*d_TP*cosd(hor_tu(2,u)) );
    hor_tu(1,u) = 180 - asind( d_tu(2,u)*sind(hor_tu(2,u))/d_tu(1,u) );
end


hor_tu(hor_tu==0) = 0.000000001;
hor_1all = hor_tu(1,1:Nu_TP1);
hor_2all = hor_tu(2,Nu_TP1+1:Nu_all);

% 基地局1についてエリアカウント
for ai = 1:N_area_1TP
    au = find( ( area_boundary(ai) < hor_1all ) & ( hor_1all <= area_boundary(ai+1) ) );
    
    if isempty(au)
        count_nua = count_nua + 1;
        nua(count_nua) = ai;
        
    elseif length(au) == 1
        area_user(ai,1) = au;
        u2a(au) = ai;
        N_aut(ai,trial) = 1;
        
    else
        count_mua1 = count_mua1 + 1;
        mua1(count_mua1) = ai;
        area_user(ai,1:length(au)) = au;
        u2a(au) = ai;
        N_aut(ai,trial) = length(au);
        
    end
end

% 基地局２についてエリアカウント
for ai = N_area_1TP+1:N_area
    au = find( ( area_boundary(ai-N_area_1TP) < hor_2all ) & ( hor_2all <= area_boundary(ai-N_area_1TP+1) ) );
    
    if isempty(au)
        count_nua = count_nua + 1;
        nua(count_nua) = ai;
        
    elseif length(au) == 1
        area_user(ai,1) = au+Nu_TP1;
        u2a(au+Nu_TP1) = ai;
        N_aut(ai,trial) = 1;
        
    else
        count_mua2 = count_mua2 + 1;
        mua2(count_mua2) = ai;
        area_user(ai,1:length(au)) = au+Nu_TP1;
        u2a(au+Nu_TP1) = ai;
        N_aut(ai,trial) = length(au);
        
    end
end

nua(nua == 0) = [];
mua1(mua1 == 0) = [];
mua2(mua2 == 0) = [];


% 複数ユーザエリアがない場合は1ユーザエリアで代用
if isempty(mua1)
    mua1 = 1:N_area_1TP;
    mua1(ismember(mua1,nua)) = [];
end

if isempty(mua2)
    mua2 = N_area_1TP+1:N_area;
    mua2(ismember(mua2,nua)) = [];
end
%}

%{
if length(mua1) < 2
    mua1 = 1:N_area_1TP;
    mua1(ismember(mua1,nua)) = [];
end

if length(mua2) < 2
    mua2 = N_area_1TP+1:N_area;
    mua2(ismember(mua2,nua)) = [];
end
%}




% 従来手法の切り替えのための仕分け
left_user1 = find(hor_1all < 90);
right_user2 = find(hor_2all > 90);
right_user2 = right_user2 + Nu_TP1;

N_left1 = length(left_user1);
N_right2 = length(right_user2);

if isempty(left_user1)
    UC1ce = [];
else
    UC1ce = combnk(left_user1,Nu_1RB);
end

if isempty(right_user2)
    UC2co = [];
else
    UC2co = combnk(right_user2,Nu_1RB);
end





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

%% 距離に応じて伝搬ロスを決定 UMiセルモデルの場合
% UMi-Street Canyon cellモデルでの伝搬ロス

for t = 1:N_TP
    for u = 1:Nu_all
        if d_tu(t,u) < 4*(h_BS-1)*(h_UT-1)*fc/c
            PL_dB_tu(t,u) = 32.4 + 21*log10(sqrt(d_tu(t,u)^2+10^2)) + 20*log10(fc/(10^9));
        else
            PL_dB_tu(t,u) = 32.4 + 40*log10(sqrt(d_tu(t,u)^2+10^2)) + 20*log10(fc/(10^9)) - 9.5*log10(312^2+(h_BS-h_UT)^2);
        end
    end
end

%{
for t = 1:N_TP
    for u = 1:N_user_all
    
P_LOS = 18/d_tu(t,u) * exp(-d_tu(t,u)/36)*(1-18/d_tu(t,u));

if P_LOS > rand
    PL_dB_tu(t,u) = 32.4 + 21*log10(d_tu(t,u)) + 20*log10(fc/(10^9));
else
    PL_dB_tu(t,u) = 22.4 + 35.3*log10(d_tu(t,u)) + 21.3*log10(fc/(10^9));
end

    end
end
%}


%{
%% 距離に応じて伝搬ロスを決定 UMaセルモデルの場合

for t = 1:N_TP
    for u = 1:N_user_all
    
P_LOS = min( 18/d_tu(t,u),1 )*(1-exp(-d_tu(t,u)/d_LOS))+exp(-d_tu(t,u)/d_LOS);

if P_LOS > rand
    PL_dB_tu(t,u) = 28.0 + ple_LOS*10*log10(d_tu(t,u)) + 20*log10(fc/(10^9));
else
    PL_dB_tu(t,u) = 22.7 + ple_NLOS*10*log10(d_tu(t,u)) + 26*log10(fc/(10^9));
end

    end
end

%}




%% サブキャリアごとに変数を格納
for k = 1:N_subcar

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
    
    P_tul(1,1,:) = ( R_signal11.*conj(R_signal11) ) * 10^(-PL_dB_tu(1,1)/10);
    P_tul(2,1,:) = ( R_signal21.*conj(R_signal21) ) * 10^(-PL_dB_tu(2,1)/10);
    P_tul(1,2,:) = ( R_signal12.*conj(R_signal12) ) * 10^(-PL_dB_tu(1,2)/10);
    P_tul(2,2,:) = ( R_signal22.*conj(R_signal22) ) * 10^(-PL_dB_tu(2,2)/10);
    P_tul(1,3,:) = ( R_signal13.*conj(R_signal13) ) * 10^(-PL_dB_tu(1,3)/10);
    P_tul(2,3,:) = ( R_signal23.*conj(R_signal23) ) * 10^(-PL_dB_tu(2,3)/10);
    P_tul(1,4,:) = ( R_signal14.*conj(R_signal14) ) * 10^(-PL_dB_tu(1,4)/10);
    P_tul(2,4,:) = ( R_signal24.*conj(R_signal24) ) * 10^(-PL_dB_tu(2,4)/10);
    P_tul(1,5,:) = ( R_signal15.*conj(R_signal15) ) * 10^(-PL_dB_tu(1,5)/10);
    P_tul(2,5,:) = ( R_signal25.*conj(R_signal25) ) * 10^(-PL_dB_tu(2,5)/10);
    P_tul(1,6,:) = ( R_signal16.*conj(R_signal16) ) * 10^(-PL_dB_tu(1,6)/10);
    P_tul(2,6,:) = ( R_signal26.*conj(R_signal26) ) * 10^(-PL_dB_tu(2,6)/10);
    P_tul(1,7,:) = ( R_signal17.*conj(R_signal17) ) * 10^(-PL_dB_tu(1,7)/10);
    P_tul(2,7,:) = ( R_signal27.*conj(R_signal27) ) * 10^(-PL_dB_tu(2,7)/10);
    P_tul(1,8,:) = ( R_signal18.*conj(R_signal18) ) * 10^(-PL_dB_tu(1,8)/10);
    P_tul(2,8,:) = ( R_signal28.*conj(R_signal28) ) * 10^(-PL_dB_tu(2,8)/10);
    P_tul(1,9,:) = ( R_signal19.*conj(R_signal19) ) * 10^(-PL_dB_tu(1,9)/10);
    P_tul(2,9,:) = ( R_signal29.*conj(R_signal29) ) * 10^(-PL_dB_tu(2,9)/10);
    P_tul(1,10,:) = ( R_signal110.*conj(R_signal110) ) * 10^(-PL_dB_tu(1,10)/10);
    P_tul(2,10,:) = ( R_signal210.*conj(R_signal210) ) * 10^(-PL_dB_tu(2,10)/10);
    
    P_tul(1,11,:) = ( R_signal111.*conj(R_signal111) ) * 10^(-PL_dB_tu(1,11)/10);
    P_tul(2,11,:) = ( R_signal211.*conj(R_signal211) ) * 10^(-PL_dB_tu(2,11)/10);
    P_tul(1,12,:) = ( R_signal112.*conj(R_signal112) ) * 10^(-PL_dB_tu(1,12)/10);
    P_tul(2,12,:) = ( R_signal212.*conj(R_signal212) ) * 10^(-PL_dB_tu(2,12)/10);
    P_tul(1,13,:) = ( R_signal113.*conj(R_signal113) ) * 10^(-PL_dB_tu(1,13)/10);
    P_tul(2,13,:) = ( R_signal213.*conj(R_signal213) ) * 10^(-PL_dB_tu(2,13)/10);
    P_tul(1,14,:) = ( R_signal114.*conj(R_signal114) ) * 10^(-PL_dB_tu(1,14)/10);
    P_tul(2,14,:) = ( R_signal214.*conj(R_signal214) ) * 10^(-PL_dB_tu(2,14)/10);
    P_tul(1,15,:) = ( R_signal115.*conj(R_signal115) ) * 10^(-PL_dB_tu(1,15)/10);
    P_tul(2,15,:) = ( R_signal215.*conj(R_signal215) ) * 10^(-PL_dB_tu(2,15)/10);
    P_tul(1,16,:) = ( R_signal116.*conj(R_signal116) ) * 10^(-PL_dB_tu(1,16)/10);
    P_tul(2,16,:) = ( R_signal216.*conj(R_signal216) ) * 10^(-PL_dB_tu(2,16)/10);
    P_tul(1,17,:) = ( R_signal117.*conj(R_signal117) ) * 10^(-PL_dB_tu(1,17)/10);
    P_tul(2,17,:) = ( R_signal217.*conj(R_signal217) ) * 10^(-PL_dB_tu(2,17)/10);
    P_tul(1,18,:) = ( R_signal118.*conj(R_signal118) ) * 10^(-PL_dB_tu(1,18)/10);
    P_tul(2,18,:) = ( R_signal218.*conj(R_signal218) ) * 10^(-PL_dB_tu(2,18)/10);
    P_tul(1,19,:) = ( R_signal119.*conj(R_signal119) ) * 10^(-PL_dB_tu(1,19)/10);
    P_tul(2,19,:) = ( R_signal219.*conj(R_signal219) ) * 10^(-PL_dB_tu(2,19)/10);
    P_tul(1,20,:) = ( R_signal120.*conj(R_signal120) ) * 10^(-PL_dB_tu(1,20)/10);
    P_tul(2,20,:) = ( R_signal220.*conj(R_signal220) ) * 10^(-PL_dB_tu(2,20)/10);
    
    P_tul(1,21,:) = ( R_signal121.*conj(R_signal121) ) * 10^(-PL_dB_tu(1,21)/10);
    P_tul(2,21,:) = ( R_signal221.*conj(R_signal221) ) * 10^(-PL_dB_tu(2,21)/10);
    P_tul(1,22,:) = ( R_signal122.*conj(R_signal122) ) * 10^(-PL_dB_tu(1,22)/10);
    P_tul(2,22,:) = ( R_signal222.*conj(R_signal222) ) * 10^(-PL_dB_tu(2,22)/10);
    P_tul(1,23,:) = ( R_signal123.*conj(R_signal123) ) * 10^(-PL_dB_tu(1,23)/10);
    P_tul(2,23,:) = ( R_signal223.*conj(R_signal223) ) * 10^(-PL_dB_tu(2,23)/10);
    P_tul(1,24,:) = ( R_signal124.*conj(R_signal124) ) * 10^(-PL_dB_tu(1,24)/10);
    P_tul(2,24,:) = ( R_signal224.*conj(R_signal224) ) * 10^(-PL_dB_tu(2,24)/10);
    
    % ユーザu, サブキャリアkのときの, 各ビームパターンでの受信信号電力
    
    
    b(1,k) = find( P_tul(1,1,:) == max(P_tul(1,1,:)) ,1 );
    b(2,k) = find( P_tul(1,2,:) == max(P_tul(1,2,:)) ,1 );
    b(3,k) = find( P_tul(1,3,:) == max(P_tul(1,3,:)) ,1 );
    b(4,k) = find( P_tul(1,4,:) == max(P_tul(1,4,:)) ,1 );
    b(5,k) = find( P_tul(1,5,:) == max(P_tul(1,5,:)) ,1 );
    b(6,k) = find( P_tul(1,6,:) == max(P_tul(1,6,:)) ,1 );
    b(7,k) = find( P_tul(1,7,:) == max(P_tul(1,7,:)) ,1 );
    b(8,k) = find( P_tul(1,8,:) == max(P_tul(1,8,:)) ,1 );
    b(9,k) = find( P_tul(1,9,:) == max(P_tul(1,9,:)) ,1 );
    b(10,k) = find( P_tul(1,10,:) == max(P_tul(1,10,:)) ,1 );
    b(11,k) = find( P_tul(1,11,:) == max(P_tul(1,11,:)) ,1 );
    b(12,k) = find( P_tul(1,12,:) == max(P_tul(1,12,:)) ,1 );
    b(13,k) = find( P_tul(2,13,:) == max(P_tul(2,13,:)) ,1 );
    b(14,k) = find( P_tul(2,14,:) == max(P_tul(2,14,:)) ,1 );
    b(15,k) = find( P_tul(2,15,:) == max(P_tul(2,15,:)) ,1 );
    b(16,k) = find( P_tul(2,16,:) == max(P_tul(2,16,:)) ,1 );
    b(17,k) = find( P_tul(2,17,:) == max(P_tul(2,17,:)) ,1 );
    b(18,k) = find( P_tul(2,18,:) == max(P_tul(2,18,:)) ,1 );
    b(19,k) = find( P_tul(2,19,:) == max(P_tul(2,19,:)) ,1 );
    b(20,k) = find( P_tul(2,20,:) == max(P_tul(2,20,:)) ,1 );
    b(21,k) = find( P_tul(2,21,:) == max(P_tul(2,21,:)) ,1 );
    b(22,k) = find( P_tul(2,22,:) == max(P_tul(2,22,:)) ,1 );
    b(23,k) = find( P_tul(2,23,:) == max(P_tul(2,23,:)) ,1 );
    b(24,k) = find( P_tul(2,24,:) == max(P_tul(2,24,:)) ,1 );
    
%% スケジューリングするのに使う3次元の箱を作る

for u1 = 1:Nu_TP1
    for u2 = 1:Nu_TP1
        power_uuk1(u1,u2,k) = P_tul(1,u1,b(u2,k) );
        power_uuk_all(u1,u2,k) = P_tul(1,u1,b(u2,k));
    end
end

for u1 = 1:Nu_TP2
    for u2 = 1:Nu_TP2
        power_uuk2(u1,u2,k) = P_tul(2,u1+Nu_TP1,b(u2+Nu_TP1,k) );
        power_uuk_all(u1+Nu_TP1,u2+Nu_TP1,k) = P_tul(2,u1+Nu_TP1,b(u2+Nu_TP1,k));
    end
end

for u1 = 1:Nu_TP1
    for u2 = 1:Nu_TP2
        
        power_uuk_all(u1,u2+Nu_TP1,k) = P_tul(2,u1,b(u2+Nu_TP1,k));
        power_uuk_all(u2+Nu_TP1,u1,k) = P_tul(1,u2+Nu_TP1,b(u1,k));
        
    end
end

if ~isempty(left_user1)
    power_uuk1ce = power_uuk1(left_user1,left_user1,:);
end

if ~isempty(right_user2)
    power_uuk2co = power_uuk2( (right_user2-Nu_TP1),(right_user2-Nu_TP1),: );
end



end   % サブキャリアごとの値格納終了　スケジューリングへ
















































































































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 比較手法の場合

cumulative_throughput = zeros(Nu_all,N_subframe);
cumulative_throughput_I0 = zeros(Nu_all,N_subframe);

combination = combnk(1:Nu_TP1,Nu_1RB);
N_combination = numel(combination(:,1));

%% 基地局１についてセル内干渉のみを考慮したスケジューリング
cumulative_throughput_all = zeros(1,Nu_TP1);
cumulative_throughput_ones = ones(1,Nu_TP1);
c1rf = zeros(N_RB,N_subframe);


%% ここからサブフレームの概念を入れたコード
for subframe = 1:N_subframe
    %% 自セル内の干渉のみを考慮したUE割り当て
    for rb = 1:N_RB
        %% 自セル内の干渉のみを考慮した推定スループットにより割り当てるUE組み合わせを探索
        % cumulative値が0のUEを優先して割り当てる[0のUEの中でスループットが高くなるUEを割り当てる]
        cumulative_throughput_temp = cumulative_throughput_all(:);
        zero_judge = all(cumulative_throughput_all(:));
        zero_user_num = 0;
        zero_user = 0;
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:Nu_TP1
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c1rf(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, c1rf(rb, subframe), combination_temp );
            
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c1rf(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all(combination_temp(c1rf(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c1rf(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c1rf(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c1rf;
            end
        end
        c1rf = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb = total_comb + N_combinations_temp;
        end
        
    end
    
    
    %%
    for rb = 1:N_RB
        [throughput_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, c1rf(rb, subframe), combination);
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(combination(c1rf(rb, subframe), j)) = cumulative_throughput_all(combination(c1rf(rb, subframe), j)) + throughput_sc(j);
        end
    end
end









%% 比較手法の場合
% 基地局２についてセル内干渉のみを考慮したスケジューリング

combination = combnk(1:Nu_TP2,Nu_1RB);
N_combination = numel(combination(:,1));

cumulative_throughput_all = zeros(1,Nu_TP2);
cumulative_throughput_ones = ones(1,Nu_TP2);
c2rf = zeros(N_RB,N_subframe);


%% ここからサブフレームの概念を入れたコード
for subframe = 1:N_subframe
    %% 自セル内の干渉のみを考慮したUE割り当て（各セル内のスループット最大）
    for rb = 1:N_RB
        %% 自セル内の干渉のみを考慮した推定スループットにより割り当てるUE組み合わせを探索
        % cumulative値が0のUEを優先して割り当てる[0のUEの中でスループットが高くなるUEを割り当てる]
        cumulative_throughput_temp = cumulative_throughput_all(:);
        zero_judge = all(cumulative_throughput_all(:));
        zero_user_num = 0;
        zero_user = 0;
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:Nu_TP2
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c2rf(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk2, noise_variance_dBm, rb, c2rf(rb, subframe), combination_temp );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c2rf(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all(combination_temp(c2rf(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c2rf(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c2rf(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c2rf;
            end
        end
        c2rf = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb = total_comb + N_combinations_temp;
        end
        
    end
    
    
    %%
    for rb = 1:N_RB
        [throughput_sc_1] = calculate_throughput_1user(power_uuk2, noise_variance_dBm, rb, c2rf(rb, subframe), combination);
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(combination(c2rf(rb, subframe), j)) = cumulative_throughput_all(combination(c2rf(rb, subframe), j)) + throughput_sc(j);
        end
    end
end




%% 実際の値

for f = 1:N_subframe
    for r = 1:N_RB
        for k = 1:N_subcar_1RB
cumulative_throughput_ut(UC1(c1rf(r,f),1),trial) = cumulative_throughput_ut(UC1(c1rf(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC1(c1rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );
          
cumulative_throughput_ut(UC2(c2rf(r,f),1),trial) = cumulative_throughput_ut(UC2(c2rf(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC2(c2rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );

cumulative_throughput_at(u2a(UC1(c1rf(r,f),1)),trial) = cumulative_throughput_at(u2a(UC1(c1rf(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC1(c1rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );
          
cumulative_throughput_at(u2a(UC2(c2rf(r,f),1)),trial) = cumulative_throughput_at(u2a(UC2(c2rf(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC2(c2rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );

a2aps(u2a(UC1(c1rf(r,f),1)),u2a(UC1(c1rf(r,f),1))) = a2aps(u2a(UC1(c1rf(r,f),1)),u2a(UC1(c1rf(r,f),1))) + power_uuk_all(UC1(c1rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k);
a2aps(u2a(UC1(c1rf(r,f),1)),u2a(UC2(c2rf(r,f),1))) = a2aps(u2a(UC1(c1rf(r,f),1)),u2a(UC2(c2rf(r,f),1))) + power_uuk_all(UC1(c1rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k);
a2aps(u2a(UC2(c2rf(r,f),1)),u2a(UC1(c1rf(r,f),1))) = a2aps(u2a(UC2(c2rf(r,f),1)),u2a(UC1(c1rf(r,f),1))) + power_uuk_all(UC2(c2rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k);
a2aps(u2a(UC2(c2rf(r,f),1)),u2a(UC2(c2rf(r,f),1))) = a2aps(u2a(UC2(c2rf(r,f),1)),u2a(UC2(c2rf(r,f),1))) + power_uuk_all(UC2(c2rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k);
%
cumulative_throughput_ut_I0(UC1(c1rf(r,f),1),trial) = cumulative_throughput_ut_I0(UC1(c1rf(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );
          
cumulative_throughput_ut_I0(UC2(c2rf(r,f),1),trial) = cumulative_throughput_ut_I0(UC2(c2rf(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

cumulative_throughput_at_I0(u2a(UC1(c1rf(r,f),1)),trial) = cumulative_throughput_at_I0(u2a(UC1(c1rf(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rf(r,f),1),UC1(c1rf(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );
          
cumulative_throughput_at_I0(u2a(UC2(c2rf(r,f),1)),trial) = cumulative_throughput_at_I0(u2a(UC2(c2rf(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rf(r,f),1),UC2(c2rf(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );
%}
        end

        
%% 実際の値
        [throughput_sc_1, throughput_sc_2] = calculate_throughput_2user(power_uuk_all, noise_variance_dBm, r, UC1(c1rf(r,f),1),UC2(c2rf(r,f),1));
        
        throughput_sc = zeros(1, Nu_1RB*2);   % 瞬時スループットに相当する
        
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        cumulative_throughput(UC1(c1rf(r,f),1), f) = cumulative_throughput(UC1(c1rf(r,f),1), f) + throughput_sc(1);
        throughput_sc(2) = sum(throughput_sc_2(:))/12; % subcarrier数で正規化
        cumulative_throughput(UC2(c2rf(r,f),1), f) = cumulative_throughput(UC2(c2rf(r,f),1), f) + throughput_sc(2);
        
        throughput_sc_1_I0 = zeros(1,N_subcar_1RB);
        throughput_sc_2_I0 = zeros(1,N_subcar_1RB);
        for sc = 1:12
    throughput_sc_1_I0(sc) = log2( 1+(power_uuk_all(UC1(c1rf(r,f),1), UC1(c1rf(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
    throughput_sc_2_I0(sc) = log2( 1+(power_uuk_all(UC2(c2rf(r,f),1), UC2(c2rf(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
        end
        cumulative_throughput_I0(UC1(c1rf(r,f),1), f) = cumulative_throughput_I0(UC1(c1rf(r,f),1), f) + sum(throughput_sc_1_I0(:))/12;
        cumulative_throughput_I0(UC2(c2rf(r,f),1), f) = cumulative_throughput_I0(UC2(c2rf(r,f),1), f) + sum(throughput_sc_2_I0(:))/12;
        % 累積スループット値（1subcarrierあたりに正規化している）
    end
    cumulative_throughput(:, f) = 7*cumulative_throughput(:, f);      % チャネルの時変動がないので7シンボル分割り当てればそのまま7倍
    cumulative_throughput_I0(:, f) = 7*cumulative_throughput_I0(:, f);
end

cumulative_throughput_ut(:,trial) = cumulative_throughput_ut(:,trial)*7;
cumulative_throughput_at(:,trial) = cumulative_throughput_at(:,trial)*7;

cumulative_throughput_ut_I0(:,trial) = cumulative_throughput_ut_I0(:,trial)*7;
cumulative_throughput_at_I0(:,trial) = cumulative_throughput_at_I0(:,trial)*7;





































































































































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 従来手法の場合

cumulative_throughput_con = zeros(Nu_all,N_subframe);
cumulative_throughput_con_I0 = zeros(Nu_all,N_subframe);

%% 基地局１について
cumulative_throughput_all = zeros(1,Nu_TP1);
cumulative_throughput_ones = ones(1,Nu_TP1);
c1rfco = zeros(N_RB,N_subframe);
c1rfce = zeros(N_RB,N_subframe);


%% ここからサブフレームの概念を入れたコード
for subframe = 1:N_subframe
    
    if rem(subframe,2) == 1                              % 奇数フレームの場合
        combination = combnk(1:Nu_TP1,Nu_1RB);
        N_combination = numel(combination(:,1));
    %% 自セル内の干渉のみを考慮したUE割り当て
    for rb = 1:N_RB
        %% 自セル内の干渉のみを考慮した推定スループットにより割り当てるUE組み合わせを探索
        % cumulative値が0のUEを優先して割り当てる[0のUEの中でスループットが高くなるUEを割り当てる]
        cumulative_throughput_temp = cumulative_throughput_all(:);
        zero_judge = all(cumulative_throughput_all(:));
        zero_user_num = 0;
        zero_user = 0;
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:Nu_TP1
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c1rfco(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, c1rfco(rb, subframe), combination_temp );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c1rfco(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all(combination_temp(c1rfco(rb, subframe), j)) )/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c1rfco(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c1rfco(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c1rfco;
            end
        end
        c1rfco = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_con = total_comb_con + N_combinations_temp;
        end
        
    end
    
    
    %%
    for rb = 1:N_RB
        [throughput_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, c1rfco(rb, subframe), combination);
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(combination(c1rfco(rb, subframe), j)) = cumulative_throughput_all(combination(c1rfco(rb, subframe), j)) + throughput_sc(j);
        end
    end
    
    
    
    

    
    
    else                                           % 偶数フレームの場合
        
        if isempty(left_user1)
            c1rfce(:, subframe) = 0;
            
        else
        combination = combnk(1:N_left1,Nu_1RB);
        N_combination = numel(combination(:,1));
    %% 自セル内の干渉のみを考慮したUE割り当て
    for rb = 1:N_RB
        %% 自セル内の干渉のみを考慮した推定スループットにより割り当てるUE組み合わせを探索
        % cumulative値が0のUEを優先して割り当てる[0のUEの中でスループットが高くなるUEを割り当てる]
        cumulative_throughput_temp = cumulative_throughput_all(left_user1);
        zero_judge = all(cumulative_throughput_all(left_user1));
        zero_user_num = 0;
        zero_user = 0;
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:N_left1
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c1rfce(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk1ce, noise_variance_dBm, rb, c1rfce(rb, subframe), combination_temp );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c1rfce(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all(UC1ce(combination_temp(c1rfce(rb, subframe), j))))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c1rfce(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c1rfce(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c1rfce;
            end
        end
        c1rfce = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_con = total_comb_con + N_combinations_temp;
        end
        
    end
    
    
        
    %%
    for rb = 1:N_RB
        [throughput_sc_1] = calculate_throughput_1user(power_uuk1ce, noise_variance_dBm, rb, c1rfce(rb, subframe), combination);
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(UC1ce(c1rfce(rb, subframe), j)) = cumulative_throughput_all(UC1ce(c1rfce(rb, subframe), j)) + throughput_sc(j);
        end
    end
    
        end
    
    
    end
    
end


























































%% 従来法の場合
%% 基地局２について
cumulative_throughput_all = zeros(1,Nu_all);
cumulative_throughput_ones = ones(1,Nu_all);
c2rfce = zeros(N_RB,N_subframe);
c2rfco = zeros(N_RB,N_subframe);


%% ここからサブフレームの概念を入れたコード
for subframe = 1:N_subframe
    if rem(subframe,2) == 1
        
        if isempty(right_user2)
            c2rfco(:, subframe) = 0;
            
        else
        combination = combnk(1:N_right2,Nu_1RB);
        N_combination = numel(combination(:,1));
    %% 自セル内の干渉のみを考慮したUE割り当て
    for rb = 1:N_RB
        %% 自セル内の干渉のみを考慮した推定スループットにより割り当てるUE組み合わせを探索
        % cumulative値が0のUEを優先して割り当てる[0のUEの中でスループットが高くなるUEを割り当てる]
        cumulative_throughput_temp = cumulative_throughput_all(right_user2);
        zero_judge = all(cumulative_throughput_all(right_user2));
        zero_user_num = 0;
        zero_user = 0;
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:N_right2
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c2rfco(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk2co, noise_variance_dBm, rb, c2rfco(rb, subframe), combination_temp );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c2rfco(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all( UC2co(combination_temp(c2rfco(rb, subframe), j)) ) )/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c2rfco(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c2rfco(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c2rfco;
            end
        end
        c2rfco = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_con = total_comb_con + N_combinations_temp;
        end
        
    end
        
        
    for rb = 1:N_RB
        
        [throughput_sc_1] = calculate_throughput_1user(power_uuk2co, noise_variance_dBm, rb, c2rfco(rb, subframe), combination);
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(UC2co(c2rfco(rb, subframe), j)) = cumulative_throughput_all(UC2co(c2rfco(rb, subframe), j)) + throughput_sc(j);
        end
    end
    
        end
    
    
    
    
    else
        
        combination = combnk(1:Nu_TP2,Nu_1RB);
        N_combination = numel(combination(:,1));
    %% 自セル内の干渉のみを考慮したUE割り当て
    for rb = 1:N_RB
        %% 自セル内の干渉のみを考慮した推定スループットにより割り当てるUE組み合わせを探索
        % cumulative値が0のUEを優先して割り当てる[0のUEの中でスループットが高くなるUEを割り当てる]
        cumulative_throughput_temp = cumulative_throughput_all(Nu_TP1+1:Nu_all);
        zero_judge = all(cumulative_throughput_all(Nu_TP1+1:Nu_all));
        zero_user_num = 0;
        zero_user = 0;
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:Nu_TP2
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
           
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c2rfce(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk2, noise_variance_dBm, rb, c2rfce(rb, subframe), combination_temp );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c2rfce(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all(combination_temp(c2rfce(rb, subframe), j)+Nu_TP1) )/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c2rfce(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c2rfce(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c2rfce;
            end
        end
        c2rfce = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_con = total_comb_con + N_combinations_temp;
        end
        
    end
    
    
    %%
    for rb = 1:N_RB
        [throughput_sc_1] = calculate_throughput_1user(power_uuk2, noise_variance_dBm, rb, c2rfce(rb, subframe), combination);
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(UC2(c2rfce(rb, subframe), j)) = cumulative_throughput_all(UC2(c2rfce(rb, subframe), j)) + throughput_sc(j);
        end
    end
    
        
    end
    
end






%% 従来法の場合
for f = 1:2:N_subframe-1
    for r = 1:N_RB
        if ~isempty(right_user2)
            for k = 1:N_subcar_1RB
cumulative_throughput_utc(UC1(c1rfco(r,f),1),trial) = cumulative_throughput_utc(UC1(c1rfco(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC1(c1rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );

cumulative_throughput_utc(UC2co(c2rfco(r,f),1),trial) = cumulative_throughput_utc(UC2co(c2rfco(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2co(c2rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC2co(c2rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );

cumulative_throughput_atc(u2a(UC1(c1rfco(r,f),1)),trial) = cumulative_throughput_atc(u2a(UC1(c1rfco(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC1(c1rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );

cumulative_throughput_atc(u2a(UC2co(c2rfco(r,f),1)),trial) = cumulative_throughput_atc(u2a(UC2co(c2rfco(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2co(c2rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC2co(c2rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );
            
a2apsc(u2a(UC1(c1rfco(r,f),1)),u2a(UC1(c1rfco(r,f),1))) = a2apsc(u2a(UC1(c1rfco(r,f),1)),u2a(UC1(c1rfco(r,f),1))) + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC1(c1rfco(r,f),1)),u2a(UC2co(c2rfco(r,f),1))) = a2apsc(u2a(UC1(c1rfco(r,f),1)),u2a(UC2co(c2rfco(r,f),1))) + power_uuk_all(UC1(c1rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2co(c2rfco(r,f),1)),u2a(UC1(c1rfco(r,f),1))) = a2apsc(u2a(UC2co(c2rfco(r,f),1)),u2a(UC1(c1rfco(r,f),1))) + power_uuk_all(UC2co(c2rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2co(c2rfco(r,f),1)),u2a(UC2co(c2rfco(r,f),1))) = a2apsc(u2a(UC2co(c2rfco(r,f),1)),u2a(UC2co(c2rfco(r,f),1))) + power_uuk_all(UC2co(c2rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k);
                
cumulative_throughput_utc_I0(UC1(c1rfco(r,f),1),trial) = cumulative_throughput_utc_I0(UC1(c1rfco(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );

cumulative_throughput_utc_I0(UC2co(c2rfco(r,f),1),trial) = cumulative_throughput_utc_I0(UC2co(c2rfco(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2co(c2rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );

cumulative_throughput_atc_I0(u2a(UC1(c1rfco(r,f),1)),trial) = cumulative_throughput_atc_I0(u2a(UC1(c1rfco(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );

cumulative_throughput_atc_I0(u2a(UC2co(c2rfco(r,f),1)),trial) = cumulative_throughput_atc_I0(u2a(UC2co(c2rfco(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2co(c2rfco(r,f),1),UC2co(c2rfco(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );
            
            end
        %% 実際の値
        [throughput_sc_1, throughput_sc_2] = calculate_throughput_2user(power_uuk_all, noise_variance_dBm, r, UC1(c1rfco(r,f),1), UC2co(c2rfco(r,f),1));
        
        throughput_sc = zeros(1, Nu_1RB*2);   % 瞬時スループットに相当する
        
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        cumulative_throughput_con(UC1(c1rfco(r,f),1), f) = cumulative_throughput_con(UC1(c1rfco(r,f),1), f) + throughput_sc(1);
        throughput_sc(2) = sum(throughput_sc_2(:))/12; % subcarrier数で正規化
        cumulative_throughput_con(UC2co(c2rfco(r,f),1), f) = cumulative_throughput_con(UC2co(c2rfco(r,f),1), f) + throughput_sc(2);
        
        % 累積スループット値（1subcarrierあたりに正規化している）

        throughput_sc_1_I0 = zeros(1,N_subcar_1RB);
        throughput_sc_2_I0 = zeros(1,N_subcar_1RB);
        for sc = 1:12
    throughput_sc_1_I0(sc) = log2( 1+(power_uuk_all(UC1(c1rfco(r,f),1), UC1(c1rfco(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
    throughput_sc_2_I0(sc) = log2( 1+(power_uuk_all(UC2co(c2rfco(r,f),1), UC2co(c2rfco(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
        end
        cumulative_throughput_con_I0(UC1(c1rfco(r,f),1), f) = cumulative_throughput_con_I0(UC1(c1rfco(r,f),1), f) + sum(throughput_sc_1_I0(:))/12;
        cumulative_throughput_con_I0(UC2co(c2rfco(r,f),1), f) = cumulative_throughput_con_I0(UC2co(c2rfco(r,f),1), f) + sum(throughput_sc_2_I0(:))/12;
        % 累積スループット値（1subcarrierあたりに正規化している）
        
        else
            for k = 1:N_subcar_1RB
cumulative_throughput_utc(UC1(c1rfco(r,f),1),trial) = cumulative_throughput_utc(UC1(c1rfco(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

cumulative_throughput_atc(u2a(UC1(c1rfco(r,f),1)),trial) = cumulative_throughput_atc(u2a(UC1(c1rfco(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

a2apsc(u2a(UC1(c1rfco(r,f),1)),u2a(UC1(c1rfco(r,f),1))) = a2apsc(u2a(UC1(c1rfco(r,f),1)),u2a(UC1(c1rfco(r,f),1))) + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k);

cumulative_throughput_utc_I0(UC1(c1rfco(r,f),1),trial) = cumulative_throughput_utc_I0(UC1(c1rfco(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

cumulative_throughput_atc_I0(u2a(UC1(c1rfco(r,f),1)),trial) = cumulative_throughput_atc_I0(u2a(UC1(c1rfco(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1(c1rfco(r,f),1),UC1(c1rfco(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

            end
        [throughput_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, r, c1rfco(r,f), combnk(1:Nu_TP1,Nu_1RB));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        cumulative_throughput_con(UC1(c1rfco(r,f),1), f) = cumulative_throughput_con(UC1(c1rfco(r,f),1), f) + throughput_sc(1);
        
        throughput_sc_1_I0 = zeros(1,N_subcar_1RB);
        for sc = 1:12
    throughput_sc_1_I0(sc) = log2( 1+(power_uuk_all(UC1(c1rfco(r,f),1), UC1(c1rfco(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
        end
        cumulative_throughput_con_I0(UC1(c1rfco(r,f),1), f) = cumulative_throughput_con_I0(UC1(c1rfco(r,f),1), f) + sum(throughput_sc_1_I0(:))/12;
        
        
        end
        
    end
    cumulative_throughput_con(:, f) = 7*cumulative_throughput_con(:, f);      % チャネルの時変動がないので7シンボル分割り当てればそのまま7倍
    cumulative_throughput_con_I0(:, f) = 7*cumulative_throughput_con_I0(:, f);
end





%% 
for f = 2:2:N_subframe
    for r = 1:N_RB
        
        if ~isempty(left_user1)
            for k = 1:N_subcar_1RB
cumulative_throughput_utc(UC1ce(c1rfce(r,f),1),trial) = cumulative_throughput_utc(UC1ce(c1rfce(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1ce(c1rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC1ce(c1rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );
        
cumulative_throughput_utc(UC2(c2rfce(r,f),1),trial) = cumulative_throughput_utc(UC2(c2rfce(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC2(c2rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );

cumulative_throughput_atc(u2a(UC1ce(c1rfce(r,f),1)),trial) = cumulative_throughput_atc(u2a(UC1ce(c1rfce(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1ce(c1rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC1ce(c1rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );
        
cumulative_throughput_atc(u2a(UC2(c2rfce(r,f),1)),trial) = cumulative_throughput_atc(u2a(UC2(c2rfce(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(power_uuk_all(UC2(c2rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k) + Npw) );
            
a2apsc(u2a(UC1ce(c1rfce(r,f),1)),u2a(UC1ce(c1rfce(r,f),1))) = a2apsc(u2a(UC1ce(c1rfce(r,f),1)),u2a(UC1ce(c1rfce(r,f),1))) + power_uuk_all(UC1ce(c1rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC1ce(c1rfce(r,f),1)),u2a(UC2(c2rfce(r,f),1))) = a2apsc(u2a(UC1ce(c1rfce(r,f),1)),u2a(UC2(c2rfce(r,f),1))) + power_uuk_all(UC1ce(c1rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2(c2rfce(r,f),1)),u2a(UC1ce(c1rfce(r,f),1))) = a2apsc(u2a(UC2(c2rfce(r,f),1)),u2a(UC1ce(c1rfce(r,f),1))) + power_uuk_all(UC2(c2rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2(c2rfce(r,f),1)),u2a(UC2(c2rfce(r,f),1))) = a2apsc(u2a(UC2(c2rfce(r,f),1)),u2a(UC2(c2rfce(r,f),1))) + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k);

cumulative_throughput_utc_I0(UC1ce(c1rfce(r,f),1),trial) = cumulative_throughput_utc_I0(UC1ce(c1rfce(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC1ce(c1rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );
        
cumulative_throughput_utc_I0(UC2(c2rfce(r,f),1),trial) = cumulative_throughput_utc_I0(UC2(c2rfce(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );

cumulative_throughput_atc_I0(u2a(UC1ce(c1rfce(r,f),1)),trial) = cumulative_throughput_atc_I0(u2a(UC1ce(c1rfce(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC1ce(c1rfce(r,f),1),UC1ce(c1rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );
        
cumulative_throughput_atc_I0(u2a(UC2(c2rfce(r,f),1)),trial) = cumulative_throughput_atc_I0(u2a(UC2(c2rfce(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/(Npw) );
            
            end

%% 実際の値
        [throughput_sc_1, throughput_sc_2] = calculate_throughput_2user(power_uuk_all, noise_variance_dBm, r, UC1ce(c1rfce(r,f),1), UC2(c2rfce(r,f),1));
        
        throughput_sc = zeros(1, Nu_1RB*2);   % 瞬時スループットに相当する
        
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        cumulative_throughput_con(UC1ce(c1rfce(r,f),1), f) = cumulative_throughput_con(UC1ce(c1rfce(r,f),1), f) + throughput_sc(1);
        throughput_sc(2) = sum(throughput_sc_2(:))/12; % subcarrier数で正規化
        cumulative_throughput_con(UC2(c2rfce(r,f),1), f) = cumulative_throughput_con(UC2(c2rfce(r,f),1), f) + throughput_sc(2);
        
        
        throughput_sc_1_I0 = zeros(1,N_subcar_1RB);
        throughput_sc_2_I0 = zeros(1,N_subcar_1RB);
        for sc = 1:12
    throughput_sc_1_I0(sc) = log2( 1+(power_uuk_all(UC1ce(c1rfce(r,f),1), UC1ce(c1rfce(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
    throughput_sc_2_I0(sc) = log2( 1+(power_uuk_all(UC2(c2rfce(r,f),1), UC2(c2rfce(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
        end
        cumulative_throughput_con_I0(UC1ce(c1rfce(r,f),1), f) = cumulative_throughput_con_I0(UC1ce(c1rfce(r,f),1), f) + sum(throughput_sc_1_I0(:))/12;
        cumulative_throughput_con_I0(UC2(c2rfce(r,f),1), f) = cumulative_throughput_con_I0(UC2(c2rfce(r,f),1), f) + sum(throughput_sc_2_I0(:))/12;
        % 累積スループット値（1subcarrierあたりに正規化している）
        
        else
            for k = 1:N_subcar_1RB
cumulative_throughput_utc(UC2(c2rfce(r,f),1),trial) = cumulative_throughput_utc(UC2(c2rfce(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

cumulative_throughput_atc(u2a(UC2(c2rfce(r,f),1)),trial) = cumulative_throughput_atc(u2a(UC2(c2rfce(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

a2apsc(u2a(UC2(c2rfce(r,f),1)),u2a(UC2(c2rfce(r,f),1))) = a2apsc(u2a(UC2(c2rfce(r,f),1)),u2a(UC2(c2rfce(r,f),1))) + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k);

cumulative_throughput_utc_I0(UC2(c2rfce(r,f),1),trial) = cumulative_throughput_utc_I0(UC2(c2rfce(r,f),1),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );

cumulative_throughput_atc_I0(u2a(UC2(c2rfce(r,f),1)),trial) = cumulative_throughput_atc_I0(u2a(UC2(c2rfce(r,f),1)),trial) + ...
log2( 1 + power_uuk_all(UC2(c2rfce(r,f),1),UC2(c2rfce(r,f),1),N_subcar_1RB*(r-1)+k)/Npw );
            end
        [throughput_sc_1] = calculate_throughput_1user(power_uuk2, noise_variance_dBm, r, c2rfce(r,f), combnk(1:Nu_TP2,Nu_1RB));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        cumulative_throughput_con(UC2(c2rfce(r,f),1), f) = cumulative_throughput_con(UC2(c2rfce(r,f),1), f) + throughput_sc(1);
        
        
        throughput_sc_1_I0 = zeros(1,N_subcar_1RB);
        for sc = 1:12
    throughput_sc_1_I0(sc) = log2( 1+(power_uuk_all(UC2(c2rfce(r,f),1), UC2(c2rfce(r,f),1), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
        end
        cumulative_throughput_con_I0(UC2(c2rfce(r,f),1), f) = cumulative_throughput_con_I0(UC2(c2rfce(r,f),1), f) + sum(throughput_sc_1_I0(:))/12;
        
        end
        
        
        % 累積スループット値（1subcarrierあたりに正規化している）
    end
    cumulative_throughput_con(:, f) = 7*cumulative_throughput_con(:, f);      % チャネルの時変動がないので7シンボル分割り当てればそのまま7倍
    cumulative_throughput_con_I0(:, f) = 7*cumulative_throughput_con_I0(:, f);
end


cumulative_throughput_utc(:,trial) = cumulative_throughput_utc(:,trial)*7;
cumulative_throughput_atc(:,trial) = cumulative_throughput_atc(:,trial)*7;

cumulative_throughput_utc_I0(:,trial) = cumulative_throughput_utc_I0(:,trial)*7;
cumulative_throughput_atc_I0(:,trial) = cumulative_throughput_atc_I0(:,trial)*7;




























































































































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% エリアラウンドロビン+PFの場合

cumulative_throughput_pro = zeros(Nu_all,N_subframe);
cumulative_throughput_pro_I0 = zeros(Nu_all,N_subframe);
N_combination = length(AC12);

cumulative_throughput_all = zeros(1,Nu_all);
cumulative_throughput_ones = ones(1,Nu_all);

user_trf = zeros(N_TP,N_RB,N_subframe);
count_user_allocated = zeros(1,Nu_all);

c1rfp = zeros(N_RB,N_subframe);
c2rfp = zeros(N_RB,N_subframe);


%% 
for subframe = 1:N_subframe
    
    for rb = 1:N_RB
        
        tp = 1;
        area_ = AC12(carf(rb,subframe),tp);
        nnz_ = nnz(area_user(area_,:));
        
        %%
        if nnz_ == 1
            
            c1rfp(rb,subframe) = 1;
            UE_comb_selected = c1rfp;
            user_trf(tp,rb,subframe) = area_user(area_,c1rfp(rb,subframe));
            count_user_allocated(user_trf(tp,rb,subframe)) = count_user_allocated(user_trf(tp,rb,subframe)) + 1;
        
        [throughput_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, c1rfp(rb,subframe), area_user(area_,:));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all( area_user(area_,c1rfp(rb,subframe)) ) = cumulative_throughput_all( area_user(area_,c1rfp(rb,subframe)) ) + throughput_sc(j);
        end
    
        
        %%
        elseif nnz_ == 0
                
            [~,mi] = min(abs( mua1-area_ ));
            area_sub = mua1(mi);
            nnz_sub = nnz( area_user(area_sub,:) );
            
            combination = combnk(1:nnz_sub,Nu_1RB);
            N_combination = numel(combination(:,1));
            
        cumulative_throughput_temp = cumulative_throughput_all(area_user(area_sub,1:nnz_sub));
        zero_judge = all(cumulative_throughput_all(area_user(area_sub,1:nnz_sub)));
        zero_user_num = 0;
        
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:nnz_sub
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c1rfp(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, combination_temp(c1rfp(rb, subframe)), area_user(area_sub,1:nnz_sub) );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c1rfp(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all( area_user(area_sub,combination_temp(c1rfp(rb, subframe), j)) ))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c1rfp(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c1rfp(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c1rfp;
            end
        end
        c1rfp = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_pro = total_comb_pro + N_combinations_temp;
        end
        
    
        user_trf(tp,rb,subframe) = area_user(area_sub,c1rfp(rb, subframe));
        count_user_allocated(user_trf(tp,rb,subframe)) = count_user_allocated(user_trf(tp,rb,subframe)) + 1;
        
        [throughput_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, c1rfp(rb, subframe), area_user(area_sub,1:nnz_sub));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(area_user(area_sub,c1rfp(rb, subframe))) = cumulative_throughput_all(area_user(area_sub,c1rfp(rb, subframe))) + throughput_sc(j);
        end
    
        
        
        %% ユーザが複数存在するエリアが割り当てられた場合
        else
                
            combination = combnk(1:nnz_,Nu_1RB);
            N_combination = numel(combination(:,1));
            
        cumulative_throughput_temp = cumulative_throughput_all(area_user(area_,1:nnz_));
        zero_judge = all(cumulative_throughput_all(area_user(area_,1:nnz_)));
        zero_user_num = 0;
        
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:nnz_
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c1rfp(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, combination_temp(c1rfp(rb, subframe)), area_user(area_,1:nnz_) );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c1rfp(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all( area_user(area_,combination_temp(c1rfp(rb, subframe), j)) ))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c1rfp(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c1rfp(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c1rfp;
            end
        end
        c1rfp = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_pro = total_comb_pro + N_combinations_temp;
        end
        
        user_trf(tp,rb,subframe) = area_user(area_,c1rfp(rb, subframe));
        count_user_allocated(user_trf(tp,rb,subframe)) = count_user_allocated(user_trf(tp,rb,subframe)) + 1;
        
        [throughput_sc_1] = calculate_throughput_1user(power_uuk1, noise_variance_dBm, rb, c1rfp(rb, subframe), area_user(area_,1:nnz_));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(area_user(area_,c1rfp(rb, subframe))) = cumulative_throughput_all(area_user(area_,c1rfp(rb, subframe))) + throughput_sc(j);
        end
    
        end
    
            
    
    %% 基地局２の場合

        tp = 2;

        area_ = AC12(carf(rb,subframe),tp);
        nnz_ = nnz(area_user(area_,:));
        
        %%
        if nnz_ == 1
            
            c2rfp(rb,subframe) = 1;
            UE_comb_selected = c2rfp;
            user_trf(tp,rb,subframe) = area_user(area_,c2rfp(rb,subframe));
            count_user_allocated(user_trf(tp,rb,subframe)) = count_user_allocated(user_trf(tp,rb,subframe)) + 1;
    
        [throughput_sc_1] = calculate_throughput_1user(power_uuk_all, noise_variance_dBm, rb, c2rfp(rb,subframe), area_user(area_,:));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all( area_user(area_,c2rfp(rb,subframe)) ) = cumulative_throughput_all( area_user(area_,c2rfp(rb,subframe)) ) + throughput_sc(j);
        end
    
        
        %%
        elseif nnz_ == 0
                
            [~,mi] = min(abs( mua2-area_ ));
            area_sub = mua2(mi);
            nnz_sub = nnz( area_user(area_sub,:) );
            
            combination = combnk(1:nnz_sub,Nu_1RB);
            N_combination = numel(combination(:,1));
            
        cumulative_throughput_temp = cumulative_throughput_all(area_user(area_sub,1:nnz_sub));
        zero_judge = all(cumulative_throughput_all(area_user(area_sub,1:nnz_sub)));
        zero_user_num = 0;
        
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:nnz_sub
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c2rfp(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk_all, noise_variance_dBm, rb, combination_temp(c2rfp(rb, subframe)), area_user(area_sub,1:nnz_sub) );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c2rfp(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all( area_user(area_sub,combination_temp(c2rfp(rb, subframe), j)) ))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c2rfp(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c2rfp(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c2rfp;
            end
        end
        c2rfp = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_pro = total_comb_pro + N_combinations_temp;
        end
        
        user_trf(tp,rb,subframe) = area_user(area_sub,c2rfp(rb, subframe));
        count_user_allocated(user_trf(tp,rb,subframe)) = count_user_allocated(user_trf(tp,rb,subframe)) + 1;
        
        [throughput_sc_1] = calculate_throughput_1user(power_uuk_all, noise_variance_dBm, rb, c2rfp(rb, subframe), area_user(area_sub,1:nnz_sub));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(area_user(area_sub,c2rfp(rb, subframe))) = cumulative_throughput_all(area_user(area_sub,c2rfp(rb, subframe))) + throughput_sc(j);
        end
        
        
        
        %% 複数ユーザが存在するエリアが割り当てられた場合
        else
                
            combination = combnk(1:nnz_,Nu_1RB);
            N_combination = numel(combination(:,1));
            
        cumulative_throughput_temp = cumulative_throughput_all(area_user(area_,1:nnz_));
        zero_judge = all(cumulative_throughput_all(area_user(area_,1:nnz_)));
        zero_user_num = 0;
        
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
        else   % 0UE存在
            zero_user_array = find(cumulative_throughput_temp == 0);
            zero_user_num = numel(zero_user_array);
            
                combination_temp = combination;
                N_combinations_temp = numel(combination_temp(:, 1));
                removal_line = zeros(1, N_combinations_temp);
                count = 0;
                for UE_index = 1:nnz_
                    if cumulative_throughput_temp(UE_index) ~= 0
                        for combination_index = 1:N_combination
                           if combination_temp(combination_index, 1) == UE_index
                               count = count + 1;
                               removal_line(count) = combination_index;
                           end
                        end
                    end
                end
                removal_line(removal_line==0) = [];
                combination_temp(removal_line, :) = [];
                N_combinations_temp = numel(combination_temp(:,1));
            
        end
        ratio_max = 0;
        
        for UE_comb_index = 1:N_combinations_temp
            c2rfp(rb,subframe) = UE_comb_index;    % 組み合わせのインデックスが順次入っていく
            [throughput_est_sc_1] = calculate_throughput_1user(power_uuk_all, noise_variance_dBm, rb, combination_temp(c2rfp(rb, subframe)), area_user(area_,1:nnz_) );
            
            throughput_EST_sc = zeros(1, Nu_1RB);
            throughput_EST_sc(1) = sum(throughput_est_sc_1);
            
            % 累積と瞬時の比率
            ratio = 1;
            if zero_judge == 0
                normalization_value = 1;
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_ones(combination_temp(c2rfp(rb, subframe), j)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            
            elseif zero_judge == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = ( throughput_EST_sc(j)) / (( cumulative_throughput_all( area_user(area_,combination_temp(c2rfp(rb, subframe), j)) ))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c2rfp(rb, subframe), 1) == combination(comb_index, 1)
                        comb_index_according_to_combination = comb_index;
                    end
                end
                c2rfp(rb, subframe) = comb_index_according_to_combination;
                UE_comb_selected = c2rfp;
            end
        end
        c2rfp = UE_comb_selected;
        
        if N_combinations_temp > 1
            total_comb_pro = total_comb_pro + N_combinations_temp;
        end
        
        user_trf(tp,rb,subframe) = area_user(area_,c2rfp(rb, subframe));
        count_user_allocated(user_trf(tp,rb,subframe)) = count_user_allocated(user_trf(tp,rb,subframe)) + 1;
        
        [throughput_sc_1] = calculate_throughput_1user(power_uuk_all, noise_variance_dBm, rb, c2rfp(rb, subframe), area_user(area_,1:nnz_));
        
        throughput_sc = zeros(1, Nu_1RB);   % 瞬時スループットに相当する
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        
        for j = 1:Nu_1RB
            cumulative_throughput_all(area_user(area_,c2rfp(rb, subframe))) = cumulative_throughput_all(area_user(area_,c2rfp(rb, subframe))) + throughput_sc(j);
        end
    
        end
    
    end
end

        
        
        
        

        
        
%%
for f = 1:N_subframe
    for r = 1:N_RB
         for k = 1:N_subcar_1RB
cumulative_throughput_utp(user_trf(1,r,f),trial) = cumulative_throughput_utp(user_trf(1,r,f),trial) + ...
log2( 1 + power_uuk_all(user_trf(1,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k)/(power_uuk_all(user_trf(1,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k) + Npw) );
          
cumulative_throughput_utp(user_trf(2,r,f),trial) = cumulative_throughput_utp(user_trf(2,r,f),trial) + ...
log2( 1 + power_uuk_all(user_trf(2,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k)/(power_uuk_all(user_trf(2,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k) + Npw) );


cumulative_throughput_atp(u2a(user_trf(1,r,f)),trial) = cumulative_throughput_atp(u2a(user_trf(1,r,f)),trial) + ...
log2( 1 + power_uuk_all(user_trf(1,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k)/(power_uuk_all(user_trf(1,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k) + Npw) );
          
cumulative_throughput_atp(u2a(user_trf(2,r,f)),trial) = cumulative_throughput_atp(u2a(user_trf(2,r,f)),trial) + ...
log2( 1 + power_uuk_all(user_trf(2,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k)/(power_uuk_all(user_trf(2,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k) + Npw) );

a2apsp(u2a(user_trf(1,r,f)),u2a(user_trf(1,r,f))) = a2apsp(u2a(user_trf(1,r,f)),u2a(user_trf(1,r,f))) + power_uuk_all(user_trf(1,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k);
a2apsp(u2a(user_trf(1,r,f)),u2a(user_trf(2,r,f))) = a2apsp(u2a(user_trf(1,r,f)),u2a(user_trf(2,r,f))) + power_uuk_all(user_trf(1,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k);
a2apsp(u2a(user_trf(2,r,f)),u2a(user_trf(1,r,f))) = a2apsp(u2a(user_trf(2,r,f)),u2a(user_trf(1,r,f))) + power_uuk_all(user_trf(2,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k);
a2apsp(u2a(user_trf(2,r,f)),u2a(user_trf(2,r,f))) = a2apsp(u2a(user_trf(2,r,f)),u2a(user_trf(2,r,f))) + power_uuk_all(user_trf(2,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k);
         
cumulative_throughput_utp_I0(user_trf(1,r,f),trial) = cumulative_throughput_utp_I0(user_trf(1,r,f),trial) + ...
log2( 1 + power_uuk_all(user_trf(1,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k)/(Npw) );
          
cumulative_throughput_utp_I0(user_trf(2,r,f),trial) = cumulative_throughput_utp_I0(user_trf(2,r,f),trial) + ...
log2( 1 + power_uuk_all(user_trf(2,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k)/(Npw) );


cumulative_throughput_atp_I0(u2a(user_trf(1,r,f)),trial) = cumulative_throughput_atp_I0(u2a(user_trf(1,r,f)),trial) + ...
log2( 1 + power_uuk_all(user_trf(1,r,f),user_trf(1,r,f),N_subcar_1RB*(r-1)+k)/(Npw) );
          
cumulative_throughput_atp_I0(u2a(user_trf(2,r,f)),trial) = cumulative_throughput_atp_I0(u2a(user_trf(2,r,f)),trial) + ...
log2( 1 + power_uuk_all(user_trf(2,r,f),user_trf(2,r,f),N_subcar_1RB*(r-1)+k)/(Npw) );

         end

%% 実際の値
        [throughput_sc_1, throughput_sc_2] = calculate_throughput_2user(power_uuk_all, noise_variance_dBm, r, user_trf(1,r,f),user_trf(2,r,f));
        
        throughput_sc = zeros(1, Nu_1RB*2);   % 瞬時スループットに相当する
        
        throughput_sc(1) = sum(throughput_sc_1(:))/12; % subcarrier数で正規化
        cumulative_throughput_pro(user_trf(1,r,f), f) = cumulative_throughput_pro(user_trf(1,r,f), f) + throughput_sc(1);
        throughput_sc(2) = sum(throughput_sc_2(:))/12; % subcarrier数で正規化
        cumulative_throughput_pro(user_trf(2,r,f), f) = cumulative_throughput_pro(user_trf(2,r,f), f) + throughput_sc(2);
        
        throughput_sc_1_I0 = zeros(1,N_subcar_1RB);
        throughput_sc_2_I0 = zeros(1,N_subcar_1RB);
        for sc = 1:12
    throughput_sc_1_I0(sc) = log2( 1+(power_uuk_all(user_trf(1,r,f), user_trf(1,r,f), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
    throughput_sc_2_I0(sc) = log2( 1+(power_uuk_all(user_trf(2,r,f), user_trf(2,r,f), (r-1) * 12 + sc))/(10^( noise_variance_dBm / 10 )) );
        end
        cumulative_throughput_pro_I0(user_trf(1,r,f), f) = cumulative_throughput_pro_I0(user_trf(1,r,f), f) + sum(throughput_sc_1_I0(:))/12;
        cumulative_throughput_pro_I0(user_trf(2,r,f), f) = cumulative_throughput_pro_I0(user_trf(2,r,f), f) + sum(throughput_sc_2_I0(:))/12;
        % 累積スループット値（1subcarrierあたりに正規化している)
        
    end
    cumulative_throughput_pro(:, f) = 7*cumulative_throughput_pro(:, f);      % チャネルの時変動がないので7シンボル分割り当てればそのまま7倍
    cumulative_throughput_pro_I0(:, f) = 7*cumulative_throughput_pro_I0(:, f);
end


cumulative_throughput_utp(:,trial) = cumulative_throughput_utp(:,trial)*7;
cumulative_throughput_atp(:,trial) = cumulative_throughput_atp(:,trial)*7;

cumulative_throughput_utp_I0(:,trial) = cumulative_throughput_utp_I0(:,trial)*7;
cumulative_throughput_atp_I0(:,trial) = cumulative_throughput_atp_I0(:,trial)*7;


file_name = ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'];
save( [file_name,'/cumulative_throughput_',num2str(trial),'trial'] , 'cumulative_throughput', 'cumulative_throughput_con','cumulative_throughput_pro', 'cumulative_throughput_I0', 'cumulative_throughput_con_I0', 'cumulative_throughput_pro_I0','total_comb','total_comb_con','total_comb_pro','a2aps','a2apsc','a2apsp' ...
    ,'cumulative_throughput_ut','cumulative_throughput_ut_I0','cumulative_throughput_utc','cumulative_throughput_utc_I0','cumulative_throughput_utp','cumulative_throughput_utp_I0')
trial

end





sum(N_aut,2)

mean_throughput = sum(cumulative_throughput_ut,'all')/Nu_all/N_trial
mean_throughput_conventional = sum(cumulative_throughput_utc,'all')/Nu_all/N_trial
mean_throughput_proposed = sum(cumulative_throughput_utp,'all')/Nu_all/N_trial

area_throughput = sum(cumulative_throughput_at,2)./sum(N_aut,2)
area_throughput_conventional = sum(cumulative_throughput_atc,2)./sum(N_aut,2)
area_throughput_proposed = sum(cumulative_throughput_atp,2)./sum(N_aut,2)

area_throughput_conventional./area_throughput
area_throughput_proposed./area_throughput

seq_ct = reshape(cumulative_throughput_ut,1,Nu_all*N_trial);
seq_ctc = reshape(cumulative_throughput_utc,1,Nu_all*N_trial);
seq_ctp = reshape(cumulative_throughput_utp,1,Nu_all*N_trial);

total_comb/N_TP/N_RB/N_subframe/N_trial
total_comb_con/N_TP/N_RB/N_subframe/N_trial
total_comb_pro/N_TP/N_RB/N_subframe/N_trial


%% スループットのCDF
figure
cdfplot(seq_ct)
hold on
cdfplot(seq_ctc)
hold on
cdfplot(seq_ctp)

legend({'比較手法','従来手法','提案手法'},'Location','southeast','FontSize',12)
xlabel('Throughput/UE/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')