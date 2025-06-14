%チャネル容量でraitoを計算するパターン
%% 基地局を1つ設置　4ユーザを一様に分布させた場合
clear
clc
rng('shuffle');

%% シミュレーションパラメータの初期設定
c = 3e8;                   % 光速
fc = 5.2e9;                % 中心周波数
lambda = c/fc;             % 波長λは光速を周波数で割ることで得られる
d_antenna = lambda/2;      % 隣接する素子間距離
N_ver = 8;                 % 垂直方向の素子数
N_hor = 16;                % 水平方向の素子数

N_subcar = 288;                      % サブキャリア数
N_RB = 24;                           % リソースブロック数
% N_subcar_1RB = N_subcar/N_RB;
d_subcar = 120e3;                    % サブキャリア間隔, 120 kHz
bandwidth = d_subcar * N_subcar;     % 帯域幅, 大きければ大きいほど雑音電力が大きくなる
bandwidth_dB = 10*log10(bandwidth);
% f_range = fc-(bandwidth/2)+d_subcar/2 : d_subcar : fc+(bandwidth/2)-d_subcar/2;
noise_1Hz_dBm = -174;                % 単位帯域幅 1Hzあたりの雑音電力, dBm表示
Noise_Figure_dB = 9;                 % ノイズフィギュア
noise_variance_dBm = noise_1Hz_dBm + bandwidth_dB + Noise_Figure_dB;
Npw = 10^(noise_variance_dBm/10);                % ノイズの電力(mW)
Tx_1element_mW = 1000/(N_ver*N_hor);             % 各素子当たり何mWか, 振幅は1/√アンテナ素子数
Tx_1element_dBm = 10*log10(Tx_1element_mW);      % dBm表示
SN_dB_1element = Tx_1element_dBm - noise_variance_dBm; %これを真値に直してから掛ける
Desire_power_dBm = Tx_1element_dBm + 10*log10((N_ver*N_hor)^2); %ビームフォーミングで位相を揃えるために^2になる. 受信側は1Wよりも大きくなる.
SN_dB = Desire_power_dBm - noise_variance_dBm;   % ビームフォーミングを適用した場合のSNR
% SN_ratio = 10^(SN_dB/10);

N_BS = 1;
d_BS = 500;                          % 基地局間距離 参考文献から決めた
d_edge = d_BS/2;                     % 自分で決める！参考文献を参考に

%Nu_1RB = 1;                          % 1リソースブロック当たりのユーザ数　同時にデータを送るユーザの数
N_user = 8;

N_timeslot = 100*7;                  % タイムスロット数 今回は関係ない
N_subframe = N_timeslot/7;           % フレーム数 7タイムスロットが1フレーム

%Amp_ak = ones(N_hor*N_ver,N_subcar)*sqrt( (10^(Tx_1element_dBm/10))/Nu_1RB );   % 振幅を設定( mW ), 総アンテナ数×サブキャリア数
Amp_ak = ones(N_hor*N_ver,N_subcar)*sqrt( (10^(Tx_1element_dBm/10)));  

ple_LOS = 2.20;                      %ple:伝搬ロス　
ple_NLOS = 3.67;                     % 伝搬ロスの係数
d_LOS = 36;                          % LOSかNLOSかを判別するときのパラメータ
PL_dB_tu = zeros(N_BS,N_user);

N_trial = 1;

N_beam = N_subcar;                   % ディジタルビームフォーミングによって用意するビームの本数
d_hor = 180/N_beam;                  % 方位角の刻み間隔
anglerange_hor = d_hor:d_hor:180;    % 水平方向の角度の下限から上限
hor_index = anglerange_hor/d_hor;    % 水平方向のインデックス

% 基地局側でビームフォーミング重み行列Wを生成
% ビームを向ける角度,ビームを向ける方向,方位角を変化させていく
%128アンテナ×288ビーム
W = zeros(N_ver*N_hor,N_beam);

%距離の制限(ミリ波が届く距離)
distance_restriction = 100;

%通信路容量
Channel_capacity = zeros(2^N_user,288,numel(distance_restriction));

%ユーザごとのスループット
Throughput_user = zeros(N_user,288,numel(distance_restriction));

%Fairness Index
Fairness_index = zeros(numel(distance_restriction),288);

%bhを固定して, ビームを固定してワンショット
%転置させた方が楽かも
%w_BF_128_1の引数の前後を入れ替えるだけ
for bh = hor_index   %bh=1:288
    W(:,bh) = w_BF_128_1(bh*d_hor,90);  %1列目には0.625のビーム重みが入る
end              % bh番目のビームパターンに対応する重みをbh列目に代入する


% 値を格納する箱
power_uuk1 = zeros(N_user,N_user,N_subcar);  %基地局1の話
%power_uuk_all = zeros(Nu_all,Nu_all,N_subcar);
b = zeros(N_user,N_subcar);
P_ulk = zeros(N_user,N_beam,N_subcar);
d_tu = zeros(N_BS,N_user);
hor_tu = zeros(N_BS,N_user);

P_sum = zeros( N_user,N_subcar);
Eig_idx = zeros(N_user,N_subcar);

R_signal = zeros(N_user, N_beam);


cumulative_Throughput_ut = zeros(N_user,N_trial);
cumulative_Channelcapacity_ut = zeros(1,N_trial);
total_comb = 0;
%% 各試行回数ごとにランダムな環境
for trial = 1:N_trial
    
%各受信端末の各基地局から見た方位角と距離の決定

H_uka= ones(N_user,N_subcar,N_hor*N_ver); %4×288×128

for u = 1:N_user
    d_tu(1,u) = d_edge*rand;  %d=didtance t=transmissionpoint(BS) 基地局1とユーザーの距離
    hor_tu(1,u) = 180*rand;   %度
    [PL_dB,H_ka] = PL_dB_H_ak_CDL(d_tu(1,u),hor_tu(1,u));   %BSとユーザーとの水平角 
    PL_dB_tu(1,u) = PL_dB;
    H_uka(u,:,:) = H_ka;
end    

hor_tu_rad = pi.*hor_tu./180;
user_distance = zeros(N_user,N_user);


for i = 1:N_user
    for j = 1:N_user
        user_distance(i,j) = sqrt(d_tu(i)^2 + d_tu(j)^2 - 2*d_tu(i)*d_tu(j)*cos(abs(hor_tu_rad(i)-hor_tu_rad(j))));
    end
end

%%
%起点を決める
%半径L[m]以内にいるUEの数の最大値
Rank = 0;
%起点となるUE
starting_point = zeros(N_user,N_user);
%起点を決める(半径L[m]以内にいるUEの数が最も多いUEを求める)
for user_num = 1:N_user
    if nnz(user_distance(user_num,:) < distance_restriction) > Rank
        Rank = nnz(user_distance(user_num,:) < distance_restriction );    
    end
end  
for user_num = 1:N_user
    starting_member = [];
    if nnz(user_distance(user_num,:) < distance_restriction) == Rank
        starting_member = cat(2,starting_member,[find(user_distance(user_num,:) < distance_restriction)]);
        starting_point(user_num,1:numel(starting_member)) = starting_member;
    end
end
%重複の削除
starting_point = unique(starting_point,'rows');
%要素が0のみの行・列を削除
allzero_rows = [];
allzero_columns = [];
for row = 1:size(starting_point,1)
    if nnz(starting_point(row,:)) == 0
        allzero_rows = cat(2,allzero_rows,[row]);
    end
end
starting_point(allzero_rows,:) = [];
for column = 1:size(starting_point,2)
    if nnz(starting_point(:,column)) == 0
        allzero_columns = cat(2,allzero_columns,[column]);
    end
end
starting_point(:,allzero_columns) = [];

%起点ごとにユーザ数が最も多くなる組み合わせを探す
Group = zeros(N_user,N_user);
max_composition = [];
max_composition_size = 0;
%バラバラではない場合
if Rank~=1
    for start_mem = starting_point.'
        %members:起点とその周辺のユーザ
        members = start_mem.';
        max_composition_temp = max_combination(distance_restriction,user_distance,members);
        if max_composition_size <= size(max_composition_temp,2)
            max_composition = cat(1,max_composition,max_composition_temp);
            max_composition_size = size(max_composition_temp,2);
        end
    end
else
    for u = 1:N_user
    	Group(u,u) = u;
    end
end
 
%%
%残りのユーザから可能な組み合わせを見つける
%重複の削除
max_composition = unique(max_composition,'rows');

%残りのユーザ
remaining_group_idx = 0;
if nnz(max_composition) && N_user-size(max_composition,2) >= 2 
    for group1 = max_composition.'
        remaining_group_idx = remaining_group_idx+1;
        remaining_users = 1:N_user;
        remaining_users(group1)=[];
        remaining_idx = 1; 
        Group(1,1:numel(group1),remaining_group_idx) = group1 ;
        while size(remaining_users,2) >= 2
            remaining_idx = remaining_idx+1; 
            remaining_composition = max_combination(distance_restriction,user_distance,remaining_users);
            %{
            for remaining_composition_idx = 1:size(1,remaining_composition)
                remaining_group_idx = remaining_group_idx+1;
                Group(1,1:numel(group1),remaining_group_idx) = group1;
                Group(remaining_idx,1:size(2,remaining_composition),remaining_group_idx) = remaining_composition(remaining_composition_idx);
            end
            %}
            Group(remaining_idx,1:1:size(remaining_composition,2),remaining_group_idx) = remaining_composition(1,:);
            for i = 1:size(remaining_composition,2)
                remaining_users(remaining_users == remaining_composition(1,i)) = [];
            end
        end
        remaining_idx = remaining_idx+1; 
        Group(remaining_idx,1:1:size(remaining_users,2),remaining_group_idx) = remaining_users;
    end
elseif N_user-size(max_composition,2) == 1
    remaining_user = 1:N_user;
    remaining_users(max_composition)=[];
    Group = max_composition;
    Group = cat(1,Group,[remaining_users]);
elseif N_user-size(max_composition,2) == 0
    Group = max_composition;
end


%%
% サブキャリアごとに通信路容量の値を格納していく
for k = 1:N_subcar
    for i = 1:N_user
        R_signal(i,:) = sum((reshape(H_uka(i,k,:),N_hor*N_ver,1)*ones(1,N_beam)).*W.*Amp_ak ,1 ); 
        P_ulk(i,:,k) = (R_signal(i,:).*conj(R_signal(i,:))) * 10^(-PL_dB_tu(1,i)/10);
        b(i,k) = find( P_ulk(i,:,k) == max(P_ulk(i,:,k)) ,1 ); %受信電力が最大となる時のビームインデックス
    end
    P_sum(:,k) = sum(P_ulk(:,:,k),2);
end

%フレーム,RBごとに組み合わせのidxを決定する
%プロポーショナルフェアスケジューリング
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% セル内干渉のみを考慮したPFスケジューリングによってユーザ組み合わせを選択
cumulative_throughput = zeros(N_user,N_subframe);
%仮置きとして, Group_listの2つ目の場合だけで検証
combination = Group(:,:,1);
%combination = sort(combination,2,'descend');

%combination行列のの余分な部分(0行や0列)をカット
allzero_rows = [];
for row = 1:size(combination,1)
    if nnz(combination(row,:)) == 0
        allzero_rows = cat(2,allzero_rows,[row]);
    end
end
combination(allzero_rows,:) = [];
allzero_colmns = [];
for colmn = 1:size(combination,2)
    if nnz(combination(:,colmn)) == 0
        allzero_colmns = cat(2,allzero_colmns,[colmn]);
    end
end
combination(:,allzero_colmns) = [];


UC1 = combination;
%組み合わせの数
N_combination = numel(combination(:,1));
%累積スループットを入れる箱
cumulative_throughput_all = zeros(1,N_user);
cumulative_capacity_all = zeros(1,size(combination,1));
cumulative_capacity_ones = ones(1,size(combination,1));
c1rf = zeros(N_RB,N_subframe);       % 各リソースブロック, サブフレームにおけるスケジューリングによって選択されたユーザ組み合わせ

%% 各サブフレーム, 各リソースブロックごとにユーザ組み合わせを決定
for subframe = 1:N_subframe
    for rb = 1:N_RB
        %% 自セル内の干渉のみを考慮した推定スループットにより割り当てるUE組み合わせを探索
        % cumulative値が0のUEを優先して割り当てる[0のUEの中でスループットが高くなるUEを割り当てる]
        cumulative_capacity_temp = cumulative_capacity_all(:);
        zero_judge = all(cumulative_capacity_all(:));
        zero_combination_num = 0;
        %zero_user = 0;
        flag2 = 0;
        %cumulative_throughput_allの全ての要素が非ゼロ(0がない)
        if zero_judge == 1  % 0UEなし
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
            %全ての要素が非ゼロの場合はflag2=1
            flag2 = 1;
        %cumulative_throughput_allの中に0が1つ以上ある場合
        else   % 0UEが存在
            %zero_user_arrayには, 累積スループットが0のUEを入れる
            zero_combination_array = find(cumulative_capacity_temp == 0);
            %zero_user_numは累積スループットが0のUEの数
            zero_combination_num = numel(zero_combination_array);
            combination_temp = combination;
            N_combinations_temp = numel(combination_temp(:, 1));
            %leave_lineには, 残しておく組み合わせインデックスを入れる
            leave_line = zeros(1, N_combinations_temp);
            count = 0;
            for combination_index = 1:N_combinations_temp
                if cumulative_capacity_temp(combination_index) == 0
                    count = count + 1;
                    leave_line(count) = combination_index;    
                end
            end
            leave_line(leave_line==0)=[];
            combination_temp = combination_temp(leave_line,:);
            N_combinations_temp = numel(combination_temp(:,1));
        end
        %ここまでは, 累積Throuthput＝0のユーザに優先的に割り当てるためのコード
        
        ratio_max = 0;
        for UE_comb_index = 1:N_combinations_temp
            c1rf(rb,subframe) = UE_comb_index;    % 各組み合わせのインデックスが順次入っていく
            combi = combination_temp(c1rf(rb,subframe),:);
            combi = combi(combi ~= 0);
            Nu_1RB = numel(combi);
            %[throughput_est_sc_1, throughput_est_sc_2] = calculate_throughput_PF(power_uuk1, noise_variance_dBm, rb, c1rf(rb,subframe), combination_temp);
            [Channelcapacity_est_sc,Throughput_est_sc] = calculate_throughput_PF_Nuser(N_user,P_sum, b, W, H_uka, SN_dB_1element, rb, c1rf(rb,subframe), combination_temp);
            %組み合わせのインデックスに対する瞬時スループット 
            Channelcapacity_EST_sc = sum(Channelcapacity_est_sc,2);
            Throughput_EST_sc = sum(Throughput_est_sc,2);

            %累積と瞬時の比率
            ratio = 1;
            %グループのメンバーが全て累積スループット0の場合
            if flag2 == 0
                %normalization_value:正規化係数
                normalization_value = 1;
                ratio_now = (Channelcapacity_EST_sc) / (( cumulative_capacity_ones(1,c1rf(rb, subframe)))/normalization_value);
                ratio = ratio * ( 1 + ratio_now );
            elseif flag2 == 1
                normalization_value = N_RB * (subframe - 1);
                for j = 1:Nu_1RB
                    ratio_now = (Channelcapacity_EST_sc) / (( cumulative_capacity_all(1,c1rf(rb, subframe)))/normalization_value);
                    ratio = ratio * ( 1 + ratio_now );
                end
            end

           %ある組み合わせがスループット(ratio)が最大となる時
            if ratio > ratio_max
                ratio_max = ratio;
                for comb_index = 1:N_combination
                    if combination_temp(c1rf(rb, subframe),:) == combination(comb_index,:)
                        comb_index_according_to_combination = comb_index;
                        break
                    end
                end
                %c1rf:あるRB,フレームではこのインデックスを使う
                c1rf(rb, subframe) = comb_index_according_to_combination;
                %UE_comb_selectedは不要？
                UE_comb_selected = c1rf;
            end
        end
        c1rf = UE_comb_selected;      % 組み合わせの決定
        
        if N_combinations_temp > 1
            total_comb = total_comb + N_combinations_temp;
        end
    end %24このRBへの割り当てが終了
    
    %% 自セル内の干渉のみを考慮したスループット計算
    for rb = 1:N_RB
        [Channelcapacity_sc_1,Throughput_sc_1] = calculate_throughput_PF_Nuser(N_user, P_sum,b, W, H_uka, SN_dB_1element, rb, c1rf(rb,subframe), combination);
        
        % subcarrier数で正規化
        Channelcapacity_sc_temp = sum(Channelcapacity_sc_1,2)/12;
        Throughput_sc_temp = sum(Throughput_sc_1,2)./12;% 瞬時スループットに相当する
        
        cumulative_capacity_all(1,c1rf(rb, subframe)) = cumulative_capacity_all(1,c1rf(rb, subframe)) + Channelcapacity_sc_temp;
        
        Nu_1RB = nnz(combination(c1rf(rb, subframe),:));
        for j = 1:Nu_1RB
            %そのフレームでの累積スループット
            cumulative_throughput_all(1,combination(c1rf(rb, subframe), j)) = cumulative_throughput_all(1,combination(c1rf(rb, subframe), j)) + Throughput_sc_temp(combination(c1rf(rb, subframe), j),1);
        end
    end
end %100このサブフレームへの割り当てが終了


%% 実際の値 ユーザスループットのCDFを作成するため
for f = 1:N_subframe
    for r = 1:N_RB
        
        combi_UC1 = UC1(c1rf(r,f),:);
        combi_UC1 = combi_UC1(combi_UC1 ~= 0);
        Nu_1RB_UC1 = numel(combi_UC1);
        %UC1のc1rf(r,f)番目の組み合わせでの, あるRB・subframeのチャネル容量とスループット
        [Channelcapacity_sc,Throughput_sc] = calculate_throughput_PF_Nuser(N_user, P_sum,b,W, H_uka, SN_dB_1element, r, c1rf(r,f), UC1);
        for i = 1:Nu_1RB_UC1
            cumulative_Throughput_ut(UC1(c1rf(r,f),i),trial) = cumulative_Throughput_ut(UC1(c1rf(r,f),i),trial) + sum(Throughput_sc(UC1(c1rf(r,f),i),:),2);
        end   
        cumulative_Channelcapacity_ut(1,trial) = cumulative_Channelcapacity_ut(1,trial) + sum(Channelcapacity_sc(1,:),2);
        
%% 実際の値 後でFIを計算するため

        cumulative_throughput(:,f) = cumulative_throughput(:,f) + sum(Throughput_sc,2)./12;   % 瞬時スループットに相当する
        
    end
    cumulative_throughput(:, f) = 7*cumulative_throughput(:, f);      % チャネルの時変動がないので7シンボル分割り当てればそのまま7倍(7タイムスロット分)
end

%cumulative_Throughput_ut(:,trial) = cumulative_Throughput_ut(:,trial)*12*7; %12サブキャリア,7タイムスロット分
cumulative_Throughput_ut(:,trial) = cumulative_Throughput_ut(:,trial)*7;
cumulative_Channelcapacity_ut(:,trial) = cumulative_Channelcapacity_ut(:,trial)*7;

file_name = ['Result_',num2str(N_user),'_',num2str(N_trial),'trial'];
save( [file_name,'/cumulative_throughput_',num2str(trial),'trial'] , 'cumulative_throughput')
end

mean_throughput = sum(cumulative_Throughput_ut,'all')/N_user/N_trial;
mean_channelcapacity = sum(cumulative_Channelcapacity_ut,'all')/N_trial;

seq_ct = reshape(cumulative_Throughput_ut,1,N_user*N_trial);
seq_ct2 = reshape(cumulative_Channelcapacity_ut,1,N_trial);


total_comb

figure
cdfplot(seq_ct)

legend({'PFスケジューリングの場合'},'Location','southeast','FontSize',12)
xlabel('Throughput/UE/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')

figure
cdfplot(seq_ct2)

legend({'PFスケジューリングの場合'},'Location','southeast','FontSize',12)
xlabel('Channelcapacity/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')




%{
figure
polarplot(hor_tu_rad,d_tu,'*');
for i = 1:N_user
    txt = ['UE',num2str(i)];
    text(hor_tu_rad(i),d_tu(i),txt);
end
thetalim([0 180]);
rlim([0 250]);
%}

%{
dt = datetime('now');
DateString = datestr(dt);
filename_extension = '.mat';
filename =  append(DateString,filename_extension);
save(filename)
%}