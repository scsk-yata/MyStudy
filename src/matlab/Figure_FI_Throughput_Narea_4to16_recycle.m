%% FIとスループットのグラフを作成する

Nu_TP1 = 8;
Nu_TP2 = 8;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 1;
N_area = 16;

N_trial = 10000;
N_RB = 24;

N_subframe = 432;
con_start = 1;





















%% 比較手法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput' ,'area_user')
        
    if tr == N_trial
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput' ,'area_user' ,'total_comb' )
    end
    
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
    
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_con' ,'area_user')
        
    if tr == N_trial
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_con' ,'area_user' ,'total_comb_con' )
    end
    
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

N_combi_con = total_comb_con/N_trial/N_RB/N_subframe/2;
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
    %{
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','a2aps','a2apsc','a2apsp','area_user' )
    %}
    load( ['Result_16_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','a2aps','a2apsc','a2apsp','area_user' )
        %}
        %N_subframe = length(cumulative_throughput_pro);
    
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
    %{
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','a2aps','a2apsc','a2apsp','area_user' )
    %}
    load( ['Result_24_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','a2aps','a2apsc','a2apsp','area_user' )
        %}
        %N_subframe = length(cumulative_throughput_pro);
    
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
    %{
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','total_comb_pro','a2aps','a2apsc','a2apsp','area_user' )
    %}
    load( ['Result_32_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_unihor'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput_pro','a2aps','a2apsc','a2apsp','area_user' )
        %}
        %N_subframe = length(cumulative_throughput_pro);
        
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
   
   
   %
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