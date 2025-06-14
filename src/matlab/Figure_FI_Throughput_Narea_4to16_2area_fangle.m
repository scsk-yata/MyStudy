%% 従来手法の使用不可領域の切り替え角度を変化させた場合

Nu_TP1 = 12;
Nu_TP2 = 12;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 1;
N_area = 24;
N_trial = 3000;
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
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf8_',num2str(tr),'trial'] , 'cumulative_throughput' )
    
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
        '/Dataf8_',num2str(tr),'trial'] , 'cumulative_throughput_con' )
    
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

























%% 

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(24),'_',num2str(12),num2str(12),'_',num2str(2),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf6_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
    
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

Fairness_Index_proposed_6 = sum(FI(:)) / N_trial;
Throughput_proposed_6 = sum(Throughput_temp(:)) / N_trial;

    











    %% 

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(24),'_',num2str(12),num2str(12),'_',num2str(2),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf8_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
    
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

Fairness_Index_proposed_8 = sum(FI(:)) / N_trial;
Throughput_proposed_8 = sum(Throughput_temp(:)) / N_trial;
















%% 

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(24),'_',num2str(12),num2str(12),'_',num2str(2),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf9_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
    
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

Fairness_Index_proposed_9 = sum(FI(:)) / N_trial;
Throughput_proposed_9 = sum(Throughput_temp(:)) / N_trial;


    




    
    

    




   %% 

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(24),'_',num2str(12),num2str(12),'_',num2str(2),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf10_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
    
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

Fairness_Index_proposed_10 = sum(FI(:)) / N_trial;
Throughput_proposed_10 = sum(Throughput_temp(:)) / N_trial;



























   %% 

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(24),'_',num2str(12),num2str(12),'_',num2str(2),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf11_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
    
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

Fairness_Index_proposed_11 = sum(FI(:)) / N_trial;
Throughput_proposed_11 = sum(Throughput_temp(:)) / N_trial;




























   %% 

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(24),'_',num2str(12),num2str(12),'_',num2str(2),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf12_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
    
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

Fairness_Index_proposed_12 = sum(FI(:)) / N_trial;
Throughput_proposed_12 = sum(Throughput_temp(:)) / N_trial;





























   %% 

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);

for tr = 1:N_trial
    square_sum_temp = zeros(1, Nu_all);
    
    load( ['Result_',num2str(24),'_',num2str(12),num2str(12),'_',num2str(2),'_',num2str(N_trial),'trial_CDL-D'...
        '/Dataf13_',num2str(tr),'trial'] , 'cumulative_throughput_pro' )
    
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

Fairness_Index_proposed_13 = sum(FI(:)) / N_trial;
Throughput_proposed_13 = sum(Throughput_temp(:)) / N_trial;






















%% グラフにプロット

    figure
    
    plot(Fairness_Index_proposed_6, Throughput_proposed_6,'x','Linewidth',3,'MarkerSize',20)
    hold on
    
    plot(Fairness_Index_conventional, Throughput_conventional,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_proposed_8, Throughput_proposed_8,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_9, Throughput_proposed_9,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_10, Throughput_proposed_10,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_11, Throughput_proposed_11,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12, Throughput_proposed_12,'x','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_13, Throughput_proposed_13,'x','Linewidth',3,'MarkerSize',20)
    hold on
    
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    %ylim([17 inf])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput(bps/UE/Hz)','FontSize',30,'FontName','Arial')
    
   legend({'エリア6-12','従来手法（エリア7-12）','エリア8-12','エリア9-12','エリア10-12','エリア11-12','比較手法（切り替えなし）'},'Location','northwest','FontSize',20)
   