%% FIとスループットのグラフを作成する

Nu_TP1 = 16;
Nu_TP2 = 16;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 2;
N_area = 32;
N_trial = 3000;
N_RB = 24;

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





%% 比較手法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput','total_comb' )
    %{
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput','total_comb' )
        %}
    N_subframe = length(cumulative_throughput);
    
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

N_combi = total_comb/N_trial/N_RB/N_subframe/2;
Fairness_Index = sum(FI(:)) / N_trial;
Throughput = sum(Throughput_temp(:)) / N_trial;

















%% 従来法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput_con','total_comb_con' )
    %{
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_con' ,'total_comb_con' )
        %}
    N_subframe = length(cumulative_throughput_con);
    
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

N_combi_con = total_comb_con/N_trial/N_RB/N_subframe/2;
Fairness_Index_conventional = sum(FI(:)) / N_trial;
Throughput_conventional = sum(Throughput_temp(:)) / N_trial;
























%
%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro' )
    %{
    load( ['Result_8_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
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
Fairness_Index_proposed_8_nomal = sum(FI(:)) / N_trial;
Throughput_proposed_8_nomal = sum(Throughput_temp(:)) / N_trial;
%}
























%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/Data2_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro')
    %{
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
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

Fairness_Index_proposed_8_narrow = sum(FI(:)) / N_trial;
Throughput_proposed_8_narrow = sum(Throughput_temp(:)) / N_trial;



























%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro' )
    %{
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
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
Fairness_Index_proposed_12_nomal = sum(FI(:)) / N_trial;
Throughput_proposed_12_nomal = sum(Throughput_temp(:)) / N_trial;






































%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/Data4_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro' )
    %{
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
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
Fairness_Index_proposed_12_narrow5 = sum(FI(:)) / N_trial;
Throughput_proposed_12_narrow5 = sum(Throughput_temp(:)) / N_trial;


















%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/Data3_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro' )
    %{
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_AWGN'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','nua','mua1','mua2' )
        %}
        N_subframe = length(cumulative_throughput_pro);
    
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
Fairness_Index_proposed_12_narrow4 = sum(FI(:)) / N_trial;
Throughput_proposed_12_narrow4 = sum(Throughput_temp(:)) / N_trial;

















%% グラフにプロット

    figure
    
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_conventional, Throughput_conventional,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_proposed_8_nomal, Throughput_proposed_8_nomal,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_8_narrow, Throughput_proposed_8_narrow,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12_nomal, Throughput_proposed_12_nomal,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12_narrow5, Throughput_proposed_12_narrow5,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12_narrow4, Throughput_proposed_12_narrow4,'x','Linewidth',3,'MarkerSize',20)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    %ylim([17 inf])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput(bits/subcarrier/timeslot)','FontSize',30,'FontName','Arial')
    
   legend({'比較手法','従来手法','提案手法（分割エリア数８, 1,4スタート）','提案手法（分割エリア数８,1,3スタート）','提案手法（分割エリア数１２,1,6スタート）','提案手法（分割エリア数１２,1,5スタート）','提案手法（分割エリア数１２,1,4スタート）'},'Location','northwest','FontSize',20)
   
   
   
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
    
    
    %{
    %% ユーザ不在または重複エリア数
    figure
    
    plot([4,8,12,16], [N_nua_4/2,N_nua_8/2,N_nua_12/2,N_nua_16/2],'x','Linewidth',3,'MarkerSize',15)
    hold on
    plot([4,8,12,16], [N_mua_4/2,N_mua_8/2,N_mua_12/2,N_mua_16/2],'x','Linewidth',3,'MarkerSize',15)
    hold off
    set(gca,'FontSize',30)
    %ylim([1 inf])
    xlabel('1基地局あたりの送信範囲分割エリア数','FontSize',30,'FontName','Arial')
    ylabel('１試行,1送信範囲における該当エリア数','FontSize',30,'FontName','Arial')
    
    legend({'ユーザ不在エリア数','ユーザ重複エリア数'},'Location','northwest','FontSize',20)
   %}