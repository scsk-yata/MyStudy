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
Nu_TP1 = 4;
Nu_TP2 = 4;
Nu_all = Nu_TP1+Nu_TP2;
N_area = 24;
N_area_1TP = N_area/2;
%hor_1area = 180/(N_area/2);
area_boundary = [0,atand(4/N_area_1TP),atand(2*4/N_area_1TP),45,90-atand(2*4/N_area_1TP),90-atand(4/N_area_1TP)...
    ,90,90+atand(4/N_area_1TP),90+atand(2*4/N_area_1TP),135,180-atand(2*4/N_area_1TP),180-atand(4/N_area_1TP),180];

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

carf = ones(N_RB,1) * [1 14 27 40 53 66 79 92 105 118 131 144 2 15 28 41 54 67 80 93 106 119 132 133 ...
    3 16 29 42 55 68 81 94 107 120 121 134 4 17 30 43 56 69 82 95 108 109 122 135 5 18 31 44 57 70 83 96 97 110 123 136 ...
    6 19 32 45 58 71 84 85 98 111 124 137 7 20 33 46 59 72 73 86 99 112 125 138 8 21 34 47 60 61 74 87 100 113 126 139 ...
    9 22 35 48 49 62 75 88 101 114 127 140 10 23 36 37 50 63 76 89 102 115 128 141 11 24 25 38 51 64 77 90 103 116 129 142 ...
    12 13 26 39 52 65 78 91 104 117 130 143];
carf = repmat(carf,1,6);

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

file_name = ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'];
save( [file_name,'/area_user_',num2str(trial),'trial'] ,'area_user')

trial

end

