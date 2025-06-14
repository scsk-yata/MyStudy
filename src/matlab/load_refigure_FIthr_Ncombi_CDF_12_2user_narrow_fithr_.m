%% FIとスループットのグラフを作成する
clear;
load('Data_FI_Thr_Ncombi_CDF_data_8-2user_narrow')

    figure
    
    plot(Fairness_Index_proposed_12, Throughput_proposed_12,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12narrow, Throughput_proposed_12narrow,'>','Linewidth',3,'MarkerSize',20)
    hold on
    
load('Data_FI_Thr_Ncombi_CDF_data_12-2user_narrow')

    plot(Fairness_Index_proposed_12, Throughput_proposed_12,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12narrow, Throughput_proposed_12narrow,'>','Linewidth',3,'MarkerSize',20)
    hold on
 
load('Data_FI_Thr_Ncombi_CDF_data_16-2user_narrow')

    plot(Fairness_Index_proposed_12, Throughput_proposed_12,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12narrow, Throughput_proposed_12narrow,'>','Linewidth',3,'MarkerSize',20)
    hold on

    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    %ylim([20.4 20.8])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput (bps/User/Hz)','FontSize',30,'FontName','Arial')
    
   legend({'8 users per cell, 12 areas per cell, Average angle space : 90 degree','8 users per cell, 12 areas per cell, Average angle space : 60 degree'...
       '12 users per cell, 12 areas per cell, Average angle space : 90 degree','12 users per cell, 12 areas per cell, Average angle space : 60 degree'...
       ,'16 users per cell, 12 areas per cell, Average angle space : 90 degree','16 users per cell, 12 areas per cell, Average angle space : 60 degree'},'Location','northwest','FontSize',20)
   
   
   


    %%
load('Data_FI_Thr_Ncombi_CDF_data_8-2user_narrow')

figure

cdfplot(seq_ctp12*576/648)
hold on
cdfplot(seq_ctp12narrow)
hold on

load('Data_FI_Thr_Ncombi_CDF_data_12-2user_narrow')

cdfplot(seq_ctp12*576/648)
hold on
cdfplot(seq_ctp12narrow)
hold on

load('Data_FI_Thr_Ncombi_CDF_data_16-2user_narrow')

cdfplot(seq_ctp12*576/648)
hold on
cdfplot(seq_ctp12narrow)
hold on


legend({'8 users per cell, 12 areas per cell, Average angle space : 90 degree','8 users per cell, 12 areas per cell, Average angle space : 60 degree'...
       '12 users per cell, 12 areas per cell, Average angle space : 90 degree','12 users per cell, 12 areas per cell, Average angle space : 60 degree'...
       ,'16 users per cell, 12 areas per cell, Average angle space : 90 degree','16 users per cell, 12 areas per cell, Average angle space : 60 degree'},'Location','southeast','FontSize',12)
xlabel('Total Throughput /User/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')
%}