%% FIとスループットのグラフを作成する

Nu_TP1 = 8;
Nu_TP2 = 8;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 1;
N_area = 16;

N_trial = 3000;
N_RB = 24;

N_subframe = 432;
con_start = 1;

N_nua_3 = 0;
N_nua_4 = 0;
N_nua_6 = 0;
N_nua_8 = 0;
N_nua_10 = 0;
N_nua_12 = 0;
N_nua_14 = 0;
N_nua_16 = 0;

N_mua_3 = 0;
N_mua_4 = 0;
N_mua_6 = 0;
N_mua_8 = 0;
N_mua_10 = 0;
N_mua_12 = 0;
N_mua_14 = 0;
N_mua_16 = 0;

PSA2A4 = zeros(8,8);
PSA2A8 = zeros(16,16);
PSA2A12 = zeros(24,24);
PSA2A16 = zeros(32,32);
PSA2Ac4 = zeros(8,8);
PSA2Ac8 = zeros(16,16);
PSA2Ac12 = zeros(24,24);
PSA2Ac16 = zeros(32,32);
PSA2Ap4 = zeros(8,8);
PSA2Ap8 = zeros(16,16);
PSA2Ap12 = zeros(24,24);
PSA2Ap16 = zeros(32,32);

ratio_nml_4 = zeros(8,3);
ratio_nml_8 = zeros(16,3);
ratio_nml_12 = zeros(24,3);
ratio_nml_16 = zeros(32,3);
ratio_con_4 = zeros(8,3);
ratio_con_8 = zeros(16,3);
ratio_con_12 = zeros(24,3);
ratio_con_16 = zeros(32,3);
ratio_pro_4 = zeros(8,3);
ratio_pro_8 = zeros(16,3);
ratio_pro_12 = zeros(24,3);
ratio_pro_16 = zeros(32,3);





%% 比較手法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %{
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput','total_comb' )
    %}
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput' )
        %}
    %N_subframe = length(cumulative_throughput);
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    
    sum_square(tr) = sum_square(tr)^2;
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

%N_combi = total_comb/N_trial/N_RB/N_subframe/2;
Fairness_Index = sum(FI(:)) / N_trial;
Throughput = sum(Throughput_temp(:)) / N_trial;


















%% 従来法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %{
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_con','total_comb_con' )
    %}
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_con' )
        %}
    %N_subframe = length(cumulative_throughput_con);
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_con(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_con(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    
    sum_square(tr) = sum_square(tr)^2;
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_con(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

%N_combi_con = total_comb_con/N_trial/N_RB/N_subframe/2;
Fairness_Index_conventional = sum(FI(:)) / N_trial;
Throughput_conventional = sum(Throughput_temp(:)) / N_trial;






















%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %{
    load( ['Result_8_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','a2aps','a2apsc','a2apsp','area_user' )
    %}
    load( ['Result_8_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','a2aps','a2apsc','a2apsp' )
        %}
        %N_subframe = length(cumulative_throughput_pro);
    
        PSA2A4 = PSA2A4+a2aps/N_trial;
        PSA2Ac4 = PSA2Ac4+a2apsc/N_trial;
        PSA2Ap4 = PSA2Ap4+a2apsp/N_trial;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

%N_combi_pro_4 = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_4 = sum(FI(:)) / N_trial;
Throughput_proposed_4 = sum(Throughput_temp(:)) / N_trial;






























%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %{
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','a2aps','a2apsc','a2apsp','area_user' )
    %}
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','a2aps','a2apsc','a2apsp','area_user' )
        %}
        %N_subframe = length(cumulative_throughput_pro);
    
        PSA2A8 = PSA2A8+a2aps/N_trial;
        PSA2Ac8 = PSA2Ac8+a2apsc/N_trial;
        PSA2Ap8 = PSA2Ap8+a2apsp/N_trial;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

%N_combi_pro_8 = total_comb_pro/N_trial/N_RB/N_subframe/2;

Fairness_Index_proposed_8 = sum(FI(:)) / N_trial;
Throughput_proposed_8 = sum(Throughput_temp(:)) / N_trial;































%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %{
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','a2aps','a2apsc','a2apsp','area_user' )
    %}
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','a2aps','a2apsc','a2apsp','area_user' )
        %}
        %N_subframe = length(cumulative_throughput_pro);
    
        PSA2A12 = PSA2A12+a2aps/N_trial;
        PSA2Ac12 = PSA2Ac12+a2apsc/N_trial;
        PSA2Ap12 = PSA2Ap12+a2apsp/N_trial;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

%N_combi_pro_12 = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_12 = sum(FI(:)) / N_trial;
Throughput_proposed_12 = sum(Throughput_temp(:)) / N_trial;










































%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %{
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','a2aps','a2apsc','a2apsp','area_user' )
    %}
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','a2aps','a2apsc','a2apsp','area_user' )
        %}
        %N_subframe = length(cumulative_throughput_pro);
        
        PSA2A16 = PSA2A16+a2apsp/N_trial;
        PSA2Ac16 = PSA2Ac16+a2apsp/N_trial;
        PSA2Ap16 = PSA2Ap16+a2apsp/N_trial;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

%N_combi_pro_16 = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_16 = sum(FI(:)) / N_trial;
Throughput_proposed_16 = sum(Throughput_temp(:)) / N_trial;



























%%

N_area_1TP = 4;

for a = 1:N_area_1TP
    ratio_nml_4(a,:) = [1, (sum(PSA2A4(a,1:N_area_1TP))-PSA2A4(a,a))/PSA2A4(a,a)/(N_area_1TP-1), sum(PSA2A4(a,N_area_1TP+1:2*N_area_1TP))/PSA2A4(a,a)/N_area_1TP];
    ratio_con_4(a,:) = [1, (sum(PSA2Ac4(a,1:N_area_1TP))-PSA2Ac4(a,a))/PSA2Ac4(a,a)/(N_area_1TP-1), sum(PSA2Ac4(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ac4(a,a)/N_area_1TP];
    ratio_pro_4(a,:) = [1, (sum(PSA2Ap4(a,1:N_area_1TP))-PSA2Ap4(a,a))/PSA2Ap4(a,a)/(N_area_1TP-1), sum(PSA2Ap4(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ap4(a,a)/N_area_1TP];
    
end

for a = N_area_1TP+1:N_area_1TP*2
    ratio_nml_4(a,:) = [1, (sum(PSA2A4(a,N_area_1TP+1:2*N_area_1TP))-PSA2A4(a,a))/PSA2A4(a,a)/(N_area_1TP-1), sum(PSA2A4(a,1:N_area_1TP))/PSA2A4(a,a)/N_area_1TP];
    ratio_con_4(a,:) = [1, (sum(PSA2Ac4(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ac4(a,a))/PSA2Ac4(a,a)/(N_area_1TP-1), sum(PSA2Ac4(a,1:N_area_1TP))/PSA2Ac4(a,a)/N_area_1TP];
    ratio_pro_4(a,:) = [1, (sum(PSA2Ap4(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ap4(a,a))/PSA2Ap4(a,a)/(N_area_1TP-1), sum(PSA2Ap4(a,1:N_area_1TP))/PSA2Ap4(a,a)/N_area_1TP];
    
end





N_area_1TP = 8;

for a = 1:N_area_1TP
    ratio_nml_8(a,:) = [1, (sum(PSA2A8(a,1:N_area_1TP))-PSA2A8(a,a))/PSA2A8(a,a)/(N_area_1TP-1), sum(PSA2A8(a,N_area_1TP+1:2*N_area_1TP))/PSA2A8(a,a)/N_area_1TP];
    ratio_con_8(a,:) = [1, (sum(PSA2Ac8(a,1:N_area_1TP))-PSA2Ac8(a,a))/PSA2Ac8(a,a)/(N_area_1TP-1), sum(PSA2Ac8(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ac8(a,a)/N_area_1TP];
    ratio_pro_8(a,:) = [1, (sum(PSA2Ap8(a,1:N_area_1TP))-PSA2Ap8(a,a))/PSA2Ap8(a,a)/(N_area_1TP-1), sum(PSA2Ap8(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ap8(a,a)/N_area_1TP];
    
end

for a = N_area_1TP+1:N_area_1TP*2
    ratio_nml_8(a,:) = [1, (sum(PSA2A8(a,N_area_1TP+1:2*N_area_1TP))-PSA2A8(a,a))/PSA2A8(a,a)/(N_area_1TP-1), sum(PSA2A8(a,1:N_area_1TP))/PSA2A8(a,a)/N_area_1TP];
    ratio_con_8(a,:) = [1, (sum(PSA2Ac8(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ac8(a,a))/PSA2Ac8(a,a)/(N_area_1TP-1), sum(PSA2Ac8(a,1:N_area_1TP))/PSA2Ac8(a,a)/N_area_1TP];
    ratio_pro_8(a,:) = [1, (sum(PSA2Ap8(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ap8(a,a))/PSA2Ap8(a,a)/(N_area_1TP-1), sum(PSA2Ap8(a,1:N_area_1TP))/PSA2Ap8(a,a)/N_area_1TP];
    
end





N_area_1TP = 12;

for a = 1:N_area_1TP
    ratio_nml_12(a,:) = [1, (sum(PSA2A12(a,1:N_area_1TP))-PSA2A12(a,a))/PSA2A12(a,a)/(N_area_1TP-1), sum(PSA2A12(a,N_area_1TP+1:2*N_area_1TP))/PSA2A12(a,a)/N_area_1TP];
    ratio_con_12(a,:) = [1, (sum(PSA2Ac12(a,1:N_area_1TP))-PSA2Ac12(a,a))/PSA2Ac12(a,a)/(N_area_1TP-1), sum(PSA2Ac12(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ac12(a,a)/N_area_1TP];
    ratio_pro_12(a,:) = [1, (sum(PSA2Ap12(a,1:N_area_1TP))-PSA2Ap12(a,a))/PSA2Ap12(a,a)/(N_area_1TP-1), sum(PSA2Ap12(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ap12(a,a)/N_area_1TP];
    
end

for a = N_area_1TP+1:N_area_1TP*2
    ratio_nml_12(a,:) = [1, (sum(PSA2A12(a,N_area_1TP+1:2*N_area_1TP))-PSA2A12(a,a))/PSA2A12(a,a)/(N_area_1TP-1), sum(PSA2A12(a,1:N_area_1TP))/PSA2A12(a,a)/N_area_1TP];
    ratio_con_12(a,:) = [1, (sum(PSA2Ac12(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ac12(a,a))/PSA2Ac12(a,a)/(N_area_1TP-1), sum(PSA2Ac12(a,1:N_area_1TP))/PSA2Ac12(a,a)/N_area_1TP];
    ratio_pro_12(a,:) = [1, (sum(PSA2Ap12(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ap12(a,a))/PSA2Ap12(a,a)/(N_area_1TP-1), sum(PSA2Ap12(a,1:N_area_1TP))/PSA2Ap12(a,a)/N_area_1TP];
    
end






N_area_1TP = 16;

for a = 1:N_area_1TP
    ratio_nml_16(a,:) = [1, (sum(PSA2A16(a,1:N_area_1TP))-PSA2A16(a,a))/PSA2A16(a,a)/(N_area_1TP-1), sum(PSA2A16(a,N_area_1TP+1:2*N_area_1TP))/PSA2A16(a,a)/N_area_1TP];
    ratio_con_16(a,:) = [1, (sum(PSA2Ac16(a,1:N_area_1TP))-PSA2Ac16(a,a))/PSA2Ac16(a,a)/(N_area_1TP-1), sum(PSA2Ac16(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ac16(a,a)/N_area_1TP];
    ratio_pro_16(a,:) = [1, (sum(PSA2Ap16(a,1:N_area_1TP))-PSA2Ap16(a,a))/PSA2Ap16(a,a)/(N_area_1TP-1), sum(PSA2Ap16(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ap16(a,a)/N_area_1TP];
    
end

for a = N_area_1TP+1:N_area_1TP*2
    ratio_nml_16(a,:) = [1, (sum(PSA2A16(a,N_area_1TP+1:2*N_area_1TP))-PSA2A16(a,a))/PSA2A16(a,a)/(N_area_1TP-1), sum(PSA2A16(a,1:N_area_1TP))/PSA2A16(a,a)/N_area_1TP];
    ratio_con_16(a,:) = [1, (sum(PSA2Ac16(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ac16(a,a))/PSA2Ac16(a,a)/(N_area_1TP-1), sum(PSA2Ac16(a,1:N_area_1TP))/PSA2Ac16(a,a)/N_area_1TP];
    ratio_pro_16(a,:) = [1, (sum(PSA2Ap16(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ap16(a,a))/PSA2Ap16(a,a)/(N_area_1TP-1), sum(PSA2Ap16(a,1:N_area_1TP))/PSA2Ap16(a,a)/N_area_1TP];
    
end


ratio_nml_4(:,3)
ratio_con_4(:,3)
ratio_pro_4(:,3)
ratio_nml_8(:,3)
ratio_con_8(:,3)
ratio_pro_8(:,3)
ratio_nml_12(:,3)
ratio_con_12(:,3)
ratio_pro_12(:,3)
ratio_nml_16(:,3)
ratio_con_16(:,3)
ratio_pro_16(:,3)





%{
%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_8_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
    %{
    load( ['Result_8_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
    N_nua_4 = nnz(nua)/N_trial+N_nua_4;
    N_mua_4 = (nnz(mua1)+nnz(mua2))/N_trial+N_mua_4;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

N_combi_pro_4 = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_4 = sum(FI(:)) / N_trial;
Throughput_proposed_4 = sum(Throughput_temp(:)) / N_trial;

























%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
    %{
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
    N_nua_8 = nnz(nua)/N_trial+N_nua_8;
    N_mua_8 = (nnz(mua1)+nnz(mua2))/N_trial+N_mua_8;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

N_combi_pro_8 = total_comb_pro/N_trial/N_RB/N_subframe/2;

Fairness_Index_proposed_8 = sum(FI(:)) / N_trial;
Throughput_proposed_8 = sum(Throughput_temp(:)) / N_trial;



























%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
    %{
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
    N_nua_12 = nnz(nua)/N_trial+N_nua_12;
    N_mua_12 = (nnz(mua1)+nnz(mua2))/N_trial+N_mua_12;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

N_combi_pro_12 = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_12 = sum(FI(:)) / N_trial;
Throughput_proposed_12 = sum(Throughput_temp(:)) / N_trial;






































%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
    %{
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
    N_nua_16 = nnz(nua)/N_trial+N_nua_16;
    N_mua_16 = (nnz(mua1)+nnz(mua2))/N_trial+N_mua_16;

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

N_combi_pro_16 = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_16 = sum(FI(:)) / N_trial;
Throughput_proposed_16 = sum(Throughput_temp(:)) / N_trial;

%}



















%% グラフにプロット

    figure
    
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_conventional, Throughput_conventional,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_proposed_4, Throughput_proposed_4,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_8, Throughput_proposed_8,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12, Throughput_proposed_12,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16, Throughput_proposed_16,'x','Linewidth',3,'MarkerSize',20)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    %ylim([17 inf])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput(bps/UE/Hz)','FontSize',30,'FontName','Arial')
    
   legend({'比較手法','従来手法','提案手法（分割エリア数４）','提案手法（分割エリア数８）','提案手法（分割エリア数１２）','提案手法（分割エリア数１６）'},'Location','northwest','FontSize',20)
   
   
   
   %{
   %% 候補組み合わせ数
   figure
    
    plot([1,2,4,8,12,16], [N_combi,N_combi_con,N_combi_pro_4,N_combi_pro_8,N_combi_pro_12,N_combi_pro_16],'x','Linewidth',3,'MarkerSize',15)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    %ylim([1 inf])
    xlabel('1基地局あたりの送信範囲分割エリア数','FontSize',30,'FontName','Arial')
    ylabel('候補組み合わせ数(/RB/Subframe/Trial/BS)','FontSize',30,'FontName','Arial')
    
   %}