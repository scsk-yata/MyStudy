%% FIとスループットのグラフを作成する

Nu_TP1 = 16;
Nu_TP2 = 16;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 2;
N_trial = 1000;

N_timeslot = 100*7;                  % タイムスロット数
N_subframe = N_timeslot/7;           % フレーム数

N_pattern = 1;

con_start = 1;

N_RB = 24;



%% 比較手法の場合

FI = zeros(1,N_trial);
Throughput_temp = zeros(1,N_trial);
sum_square = zeros(1,N_trial);
square_sum = zeros(1,N_trial);


for tr = 1:N_trial
    square_sum_temp = zeros(1,Nu_all);
    
    load( ['Result_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput' )
    
        
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

Fairness_Index = sum(FI(:)) / N_trial
Throughput = sum(Throughput_temp(:)) / N_trial;




%% グラフにプロット

    figure
    
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    
    set(gca,'FontSize',30)
    xlim([0 1])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput(bits/user/subcarrier/timeslot)','FontSize',30,'FontName','Arial')
    
   legend({'PFスケジューリングの場合'},'Location','northwest','FontSize',20)