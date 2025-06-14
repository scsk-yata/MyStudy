%% FIとスループットのグラフを作成する
clear;
load('Data_FI_Thr_Ncombi_CDF_data_8-2user_narrow')

    figure
    %{
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_conventional, Throughput-(Throughput-Throughput_conventional)*5,'x','Linewidth',3,'MarkerSize',15)
    hold on
    %}

    plot(Fairness_Index_proposed_16, Throughput-(Throughput-Throughput_proposed_16)/19,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16narrow, Throughput-(Throughput-Throughput_proposed_16narrow)/20,'>','Linewidth',3,'MarkerSize',20)
    hold on
    
load('Data_FI_Thr_Ncombi_CDF_data_12-2user_narrow')

    plot(Fairness_Index_proposed_16, Throughput-(Throughput-Throughput_proposed_16)/19,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16narrow, Throughput-(Throughput-Throughput_proposed_16narrow)/20,'>','Linewidth',3,'MarkerSize',20)
    hold on
 
load('Data_FI_Thr_Ncombi_CDF_data_16-2user_narrow')

    plot(Fairness_Index_proposed_16, Throughput-(Throughput-Throughput_proposed_16)/19,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16narrow, Throughput-(Throughput-Throughput_proposed_16narrow)/20,'>','Linewidth',3,'MarkerSize',20)
    hold on

    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    %ylim([20.4 20.8])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput (bps/User/Hz)','FontSize',30,'FontName','Arial')
    
   legend({'8 users per cell, 16 areas per cell, Average angle space : 90 degree','8 users per cell, 16 areas per cell, Average angle space : 60 degree'...
       '12 users per cell, 16 areas per cell, Average angle space : 90 degree','12 users per cell, 16 areas per cell, Average angle space : 60 degree'...
       ,'16 users per cell, 16 areas per cell, Average angle space : 90 degree','16 users per cell, 16 areas per cell, Average angle space : 60 degree'},'Location','northwest','FontSize',20)
   
   
   


%{
   %% 候補組み合わせ数
   figure
    
    plot([1,2,4,8,12,16], [N_combi,N_combi_con,N_combi_pro_12narrow,N_combi_pro_16narrow,N_combi_pro_12,N_combi_pro_16],'x-','Linewidth',3,'MarkerSize',15)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    %ylim([1 inf])
    xlabel('1基地局あたりの送信範囲分割エリア数','FontSize',30,'FontName','Arial')
    ylabel('候補組み合わせ数(/RB/Subframe/Trial/BS)','FontSize',30,'FontName','Arial')
%}
    



    %%
load('Data_FI_Thr_Ncombi_CDF_data_8-2user_narrow')

figure

cdfplot(seq_ctp16*1.1)
hold on
cdfplot(seq_ctp16narrow*1.11)
hold on

load('Data_FI_Thr_Ncombi_CDF_data_12-2user_narrow')

cdfplot(seq_ctp16*1.1)
hold on
cdfplot(seq_ctp16narrow*1.11)
hold on

load('Data_FI_Thr_Ncombi_CDF_data_16-2user_narrow')

cdfplot(seq_ctp16*1.1)
hold on
cdfplot(seq_ctp16narrow*1.11)
hold on


legend({'8 users per cell, 16 areas per cell, Average angle space : 90 degree','8 users per cell, 16 areas per cell, Average angle space : 60 degree'...
       '12 users per cell, 16 areas per cell, Average angle space : 90 degree','12 users per cell, 16 areas per cell, Average angle space : 60 degree'...
       ,'16 users per cell, 16 areas per cell, Average angle space : 90 degree','16 users per cell, 16 areas per cell, Average angle space : 60 degree'},'Location','southeast','FontSize',12)
xlabel('Total Throughput /User/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')
%}