%% エリア当たりの

Nu_TP1 = 8;
Nu_TP2 = 8;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 1;
N_area = 16;

N_trial = 10000;
N_RB = 24;

N_subframe = 432;


N_UE_1area_8split = zeros();


%% 
for tr = 1:N_trial
    
load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput' ,'area_user')
        
    if tr == N_trial
    load( ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'] , 'cumulative_throughput' ,'area_user' ,'total_comb' )
    end
    for ai = 1:16
        N_UE_1area_8split(1,nnz(area_user(ai,:))) = N_UE_1area_8split(1,nnz(area_user(ai,:))) + 1;
    end
    
end

N_UE_1area_8split/N_trial/16;
   








   %% 
   
   figure
    
    plot([1,2,4,8,12,16], [N_combi,N_combi_con,N_combi_pro_4,N_combi_pro_8,N_combi_pro_12,N_combi_pro_16],'x','Linewidth',3,'MarkerSize',15)
    hold on
    
    hold off
    set(gca,'FontSize',30)
    %ylim([1 inf])
    xlabel('1基地局あたりの送信範囲分割エリア数','FontSize',30,'FontName','Arial')
    ylabel('候補組み合わせ数(/RB/Subframe/Trial/BS)','FontSize',30,'FontName','Arial')
    