%% CDFのグラフを作成する
clear
Nu_TP1 = 16;
Nu_TP2 = 16;
Nu_all = Nu_TP1+Nu_TP2;
Nu_1RB = 1;
N_area_1TP = 16;
N_trial = 10000;

tr = 10000;
load( ['Result_',num2str(N_area_1TP),num2str(N_area_1TP),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial'...
        '/cumulative_throughput_',num2str(tr),'trial'],'cumulative_throughput','cumulative_throughput_ut','cumulative_throughput_utc','cumulative_throughput_utp','total_comb' )

N_subframe = length(cumulative_throughput)
N_timeslot = N_subframe*7

seq_ct = reshape(cumulative_throughput_ut,1,Nu_all*N_trial)*768/N_subframe;
seq_ctc = reshape(cumulative_throughput_utc,1,Nu_all*N_trial)*768/N_subframe;
seq_ctp = reshape(cumulative_throughput_utp,1,Nu_all*N_trial)*768/N_subframe;

figure
cdfplot(seq_ct)
hold on
cdfplot(seq_ctc)
hold on
cdfplot(seq_ctp)

legend({'比較手法','従来手法','提案手法（分割エリア数',num2str(N_area_1TP),'）'},'Location','southeast','FontSize',12)
xlabel('Total Throughput/User/Trial','FontSize',20,'FontName','Arial')
ylabel('Probability','FontSize',20,'FontName','Arial')