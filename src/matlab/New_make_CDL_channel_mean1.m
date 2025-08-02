%% CDLƒ`ƒƒƒlƒ‹‚Ìì¬

for n = 1:21844
    
distance = 50+450*rand;

[PL_dB,H_ak] = PL_dB_H_ak_mean1_ym(distance);

save(['CDL_channel_mean1_File/CDL_channel_',num2str(n),'set.mat'] ,'distance','PL_dB','H_ak' )

end