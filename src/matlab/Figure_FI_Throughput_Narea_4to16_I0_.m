%% FIとスループットのグラフを作成する

Nu_TP1 = 4;
Nu_TP2 = 4;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 1;
N_area = 8;

N_trial = 10000;
N_RB = 24;

N_subframe = 512;
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
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_add'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_I0' )
    %}
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_I0' )
        %}
    N_subframe = length(cumulative_throughput_I0);
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_I0(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    
    sum_square(tr) = sum_square(tr)^2;
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

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
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_add'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_con_I0' )
    %}
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_con_I0' )
        %}
    N_subframe = length(cumulative_throughput_con_I0);
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_con_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_con_I0(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    
    sum_square(tr) = sum_square(tr)^2;
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_con_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

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
    load( ['Result_8_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_add'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
    %}
    load( ['Result_8_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
        %}
        N_subframe = length(cumulative_throughput_pro_I0);
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

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
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_add'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
    %{
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
        %}
        N_subframe = length(cumulative_throughput_pro_I0);
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

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
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_add'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
    %{
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
        %}
        N_subframe = length(cumulative_throughput_pro_I0);
    
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

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
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_add'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
    %{
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro_I0' )
        %}
        N_subframe = length(cumulative_throughput_pro_I0);
        
        for u = 1:Nu_all
            for sf = con_start:N_subframe
                sum_square(tr) = sum_square(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
                Throughput_temp(tr) = Throughput_temp(tr) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/7/N_RB;
            end
        end
    
    sum_square(tr) = sum_square(tr)^2;    % 全スループットの和の2乗
    

        for u = 1:Nu_all
            for sf = con_start:N_subframe
                square_sum_temp(1, u) = square_sum_temp(1, u) + cumulative_throughput_pro_I0(u, sf)/(N_subframe - con_start + 1)/N_RB;
            end
            square_sum_temp(1, u) = square_sum_temp(1, u)^2;
        end           %各ユーザが受け取るスループットを2乗
    
    square_sum(tr) = Nu_all * sum(sum(square_sum_temp(:,:)));
    FI(tr) = sum_square(tr) / square_sum(tr);    
end

Fairness_Index_proposed_16 = sum(FI(:)) / N_trial;
Throughput_proposed_16 = sum(Throughput_temp(:)) / N_trial;






































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
   