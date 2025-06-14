%%
file_name_load = 'Result_1212_1616_2_5000trial';
file_name_save = 'Result_1212_1616_2_10000trial_add';

for trial = 1:5000

load( [file_name_load,'/All_Data_',num2str(trial),'trial'] )

save( [file_name_save,'/All_Data_',num2str(trial+5000),'trial'],'area_user','cumulative_throughput','cumulative_throughput_con','cumulative_throughput_pro'...
    ,'a2aps','a2apsc','a2apsp','cumulative_throughput_i0','cumulative_throughput_con_i0','cumulative_throughput_pro_i0','cumulative_throughput_o0','cumulative_throughput_con_o0','cumulative_throughput_pro_o0')
if trial == 5000
    save( [file_name_save,'/All_Data_',num2str(trial+5000),'trial'],'area_user','cumulative_throughput','cumulative_throughput_con','cumulative_throughput_pro'...
        ,'total_comb','cumulative_throughput_ut','cumulative_throughput_utc','cumulative_throughput_utp','total_comb_con','total_comb_pro','a2aps','a2apsc','a2apsp'...
        ,'cumulative_throughput_i0','cumulative_throughput_con_i0','cumulative_throughput_pro_i0','cumulative_throughput_o0','cumulative_throughput_con_o0','cumulative_throughput_pro_o0')
end

end