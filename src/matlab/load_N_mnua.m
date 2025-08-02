%% ユーザ不在, ユーザ重複エリア

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




    load( ['Result_',num2str(8),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/psa2a_All_data'] ,'total_mua','total_nua' )
    
N_mua_4 = total_mua;
N_nua_4 = total_nua;


    load( ['Result_',num2str(16),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/psa2a_All_data'] ,'total_mua','total_nua' )
    
N_mua_8 = total_mua;
N_nua_8 = total_nua;


load( ['Result_',num2str(24),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/psa2a_data5'] ,'total_mua','total_nua' )
    
N_mua_12 = total_mua;
N_nua_12 = total_nua;


load( ['Result_',num2str(32),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'...
        '/psa2a_All_data'] ,'total_mua','total_nua' )
    
N_mua_16 = total_mua;
N_nua_16 = total_nua;


    %% ユーザ不在または重複エリア数
    figure
    
    plot([4,8,12,16], [N_nua_4/8,N_nua_8/16,N_nua_12/24,N_nua_16/32],'x','Linewidth',3,'MarkerSize',15)
    hold on
    plot([4,8,12,16], [N_mua_4/8,N_mua_8/16,N_mua_12/24,N_mua_16/32],'x','Linewidth',3,'MarkerSize',15)
    hold off
    set(gca,'FontSize',30)
    %ylim([1 inf])
    xlabel('1基地局あたりの送信範囲分割エリア数','FontSize',30,'FontName','Arial')
    ylabel('該当エリアの存在割合','FontSize',30,'FontName','Arial')
    
    legend({'ユーザ不在エリア','ユーザ重複エリア'},'Location','northwest','FontSize',20)
    %}