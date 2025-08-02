clear

N_TP = 2;
Nu_1RB = 2;
Nu_TP1 = 12;
Nu_TP2 = 12;
Nu_all = Nu_TP1+Nu_TP2;
N_area = 8;
N_area_1TP = N_area/2;

file_name = ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(3000),'trial_CDL-D'];


for trial = 1:2999
    
load( [file_name,'/All_Data_',num2str(trial),'trial'] )
%load( [file_name,'/Data2_',num2str(trial),'trial'] )

%
save( [file_name,'/All_Data_',num2str(trial),'trial'],'AC1','AC2','area_user','c1rf','c1rfce','c1rfco','c1rfp','c2rf','c2rfce','c2rfco','c2rfp'...
    ,'carf1','carf2','cumulative_throughput','cumulative_throughput_con','cumulative_throughput_pro','hor_tu','power_uuk_all'...
    ,'u2a','UC1','UC1ce','UC2','UC2co')
%{
save( [file_name,'/Data2_',num2str(trial),'trial'],'AC1','AC2','area_user','c1rf','c1rfce','c1rfco','c1rfp','c2rf','c2rfce','c2rfco','c2rfp'...
    ,'carf1','carf2','cumulative_throughput','cumulative_throughput_con','cumulative_throughput_pro','hor_tu','power_uuk_all'...
    ,'total_comb','total_comb_con','total_comb_pro','u2a','UC1','UC1ce','UC2','UC2co')
%}
end