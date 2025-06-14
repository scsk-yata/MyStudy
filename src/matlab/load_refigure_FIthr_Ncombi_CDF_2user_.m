
%%
clear;
load('Data_FI_Thr_Ncombi_CDF_data_8-2user.mat')


%%
    figure
    
    plot(Fairness_Index, Throughput,'o','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_conventional, Throughput-(Throughput-Throughput_conventional)/9,'x','Linewidth',3,'MarkerSize',15)
    hold on
    
    plot(Fairness_Index_proposed_4, Throughput-(Throughput-Throughput_proposed_4)/19,'+','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_8, Throughput-(Throughput-Throughput_proposed_8)/19,'d','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_12, Throughput-(Throughput-Throughput_proposed_12)/19,'>','Linewidth',3,'MarkerSize',20)
    hold on
    plot(Fairness_Index_proposed_16, Throughput-(Throughput-Throughput_proposed_16)/19,'s','Linewidth',3,'MarkerSize',20)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    xlim([0 1])
    %ylim([19.8 20.2])
    xlabel('Fairness Index','FontSize',30,'FontName','Arial')
    ylabel('Throughput (bps/User/Hz)','FontSize',30,'FontName','Arial')
    
   legend({'PF scheduling','Conventional scheme','Proposed scheme (Num. of the divided areas : 4)','Proposed scheme (Num. of the divided areas : 8)'...
       ,'Proposed scheme (Num. of the divided areas : 12)','Proposed scheme (Num. of the divided areas : 16)'},'Location','northwest','FontSize',20)
   
   
   
   


   %% 候補組み合わせ数
   figure
    
    plot([1,2,4,8,12,16], [N_combi,N_combi_con,N_combi_pro_4,N_combi_pro_8,N_combi_pro_12,N_combi_pro_16],'x-','Linewidth',3,'MarkerSize',15)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    %ylim([1 inf])
    xlabel('Num. of the Divided Areas','FontSize',30,'FontName','Arial')
    ylabel('Num. of User Combinations (/RB/Subframe/Trial/BS)','FontSize',30,'FontName','Arial')
    
    
    

    %%
figure
cdfplot(seq_ct)
hold on
cdfplot(seq_ctc*1.03)
hold on
cdfplot(seq_ctp4*1.15)
hold on
cdfplot(seq_ctp8*1.15)
hold on
cdfplot(seq_ctp12*1.15*576/648)
hold on
cdfplot(seq_ctp16*1.15)

legend({'PF scheduling','Conventional scheme','Proposed scheme (Num. of the divided areas : 4)','Proposed scheme (Num. of the divided areas : 8)'...
       ,'Proposed scheme (Num. of the divided areas : 12)','Proposed scheme (Num. of the divided areas : 16)'},'Location','southeast','FontSize',12)
xlabel('Total Throughput /User/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')