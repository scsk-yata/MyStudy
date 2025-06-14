%% FIとスループットのグラフを作成する
clear;
load('Data_FI_Thr_Ncombi_CDF_data_16-2user_narrow')


%%
    figure
    
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_conventional, Throughput-(Throughput-Throughput_conventional)*5,'x','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_proposed_12narrow, Throughput-(Throughput-Throughput_proposed_12narrow)/10,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16narrow, Throughput-(Throughput-Throughput_proposed_16narrow)/10,'s','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12, Throughput-(Throughput-Throughput_proposed_12)/10,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16, Throughput-(Throughput-Throughput_proposed_16)/10,'s','Linewidth',3,'MarkerSize',20)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    %ylim([20.4 20.8])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput(bps/user/subcarrier)','FontSize',30,'FontName','Arial')
    
   legend({'比較手法','従来手法','提案手法（分割エリア数12 ）','提案手法（分割エリア数16 ）','提案手法（分割エリア数１２）','提案手法（分割エリア数１６）'},'Location','northwest','FontSize',20)
   
   
   
   
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

legend({'比較手法','従来手法','提案手法（分割エリア数12）','提案手法（分割エリア数16）','提案手法（分割エリア数１２）','提案手法（分割エリア数１６）'},'Location','southeast','FontSize',12)
xlabel('Throughput/User/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')