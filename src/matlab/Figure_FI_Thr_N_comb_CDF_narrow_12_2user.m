%% FIとスループットのグラフを作成する
clear;
Nu_TP1 = 12;
Nu_TP2 = 12;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 2;
N_area_1TP = 16;
N_trial = 5000;
N_RB = 24;

con_start = 1;







%% 比較手法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_',num2str(N_area_1TP),num2str(N_area_1TP),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial_narrow'] , 'cumulative_throughput' )
    %{
    load( ['Result_',num2str(N_area_1TP),num2str(N_area_1TP),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput' )
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

load( ['Result_',num2str(N_area_1TP),num2str(N_area_1TP),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_5000trial_narrow'] , 'cumulative_throughput_ut','total_comb' )

N_subframe = length(cumulative_throughput)
seq_ct = reshape(cumulative_throughput_ut,1,Nu_all*5000);
    
N_combi = total_comb/N_trial/N_RB/N_subframe/2;
Fairness_Index = sum(FI(:)) / N_trial;
Throughput = sum(Throughput_temp(:)) / N_trial;





















%% 従来手法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_',num2str(N_area_1TP),num2str(N_area_1TP),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial_narrow'] , 'cumulative_throughput_con' )
    %{
    load( ['Result_',num2str(N_area_1TP),num2str(N_area_1TP),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput_con' )
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

load( ['Result_',num2str(N_area_1TP),num2str(N_area_1TP),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_5000trial_narrow'] , 'cumulative_throughput_utc','total_comb_con' )

N_subframe = length(cumulative_throughput_con)
seq_ctc = reshape(cumulative_throughput_utc,1,Nu_all*5000);

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
    %
    load( ['Result_1212_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial_narrow'] , 'cumulative_throughput_pro' )
    %{
    load( ['Result_1212_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
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

load( ['Result_1212_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_5000trial_narrow'] , 'cumulative_throughput_utp','total_comb_pro' )

N_subframe = length(cumulative_throughput_pro)
seq_ctp12narrow = reshape(cumulative_throughput_utp,1,Nu_all*5000);

N_combi_pro_12narrow = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_12narrow = sum(FI(:)) / N_trial;
Throughput_proposed_12narrow = sum(Throughput_temp(:)) / N_trial;



























%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_1616_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial_narrow'] , 'cumulative_throughput_pro')
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

load( ['Result_1616_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_5000trial_narrow'] , 'cumulative_throughput_utp','total_comb_pro' )

N_subframe = length(cumulative_throughput_pro)
seq_ctp16narrow = reshape(cumulative_throughput_utp,1,Nu_all*5000);
    
N_combi_pro_16narrow = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_16narrow = sum(FI(:)) / N_trial;
Throughput_proposed_16narrow = sum(Throughput_temp(:)) / N_trial;




























%% 提案法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

    
for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    %
    load( ['Result_1212_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
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

load( ['Result_1212_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_5000trial'] , 'cumulative_throughput_utp','total_comb_pro' )

N_subframe = length(cumulative_throughput_pro)
seq_ctp12 = reshape(cumulative_throughput_utp,1,Nu_all*5000);

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
    load( ['Result_1616_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
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


load( ['Result_1616_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_narrow'...
        '/All_Data_5000trial'] , 'cumulative_throughput_utp','total_comb_pro' )

N_subframe = length(cumulative_throughput_pro)
seq_ctp16 = reshape(cumulative_throughput_utp,1,Nu_all*5000);

N_combi_pro_16 = total_comb_pro/N_trial/N_RB/N_subframe/2;
Fairness_Index_proposed_16 = sum(FI(:)) / N_trial;
Throughput_proposed_16 = sum(Throughput_temp(:)) / N_trial;


















%%
save('Data_FI_Thr_Ncombi_CDF_data_12-2user_narrow')


%%
    figure
    
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_conventional, Throughput_conventional,'x','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_proposed_12narrow, Throughput_proposed_12narrow,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16narrow, Throughput_proposed_16narrow,'s','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12, Throughput_proposed_12,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16, Throughput_proposed_16,'s','Linewidth',3,'MarkerSize',20)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    ylim([20.4 20.8])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput(bps/user/subcarrier)','FontSize',30,'FontName','Arial')
    
   legend({'比較手法','従来手法','提案手法（分割エリア数４）','提案手法（分割エリア数８）','提案手法（分割エリア数１２）','提案手法（分割エリア数１６）'},'Location','northwest','FontSize',20)
   
   
   
   

   %% 候補組み合わせ数
   figure
    
    plot([1,2,4,8,12,16], [N_combi,N_combi_con,N_combi_pro_12narrow,N_combi_pro_16narrow,N_combi_pro_12,N_combi_pro_16],'x-','Linewidth',3,'MarkerSize',15)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    %ylim([1 inf])
    xlabel('1基地局あたりの送信範囲分割エリア数','FontSize',30,'FontName','Arial')
    ylabel('候補組み合わせ数(/RB/Subframe/Trial/BS)','FontSize',30,'FontName','Arial')
    
    
    

    %%
figure
cdfplot(seq_ct)
hold on
cdfplot(seq_ctc)
hold on
cdfplot(seq_ctp12narrow)
hold on
cdfplot(seq_ctp16narrow)
hold on
cdfplot(seq_ctp12)
hold on
cdfplot(seq_ctp16)

legend({'比較手法','従来手法','提案手法（分割エリア数12）','提案手法（分割エリア数８）','提案手法（分割エリア数１２）','提案手法（分割エリア数１６）'},'Location','southeast','FontSize',12)
xlabel('Throughput/User/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')