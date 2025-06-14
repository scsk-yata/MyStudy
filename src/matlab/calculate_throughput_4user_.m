function [ throughput_sc_1, throughput_sc_2, throughput_sc_3, throughput_sc_4] = calculate_throughput_4user( power_uuk, noise_variance_dBm, r, u1,u2,u3,u4 )

N_subcarrier = 12;
throughput_sc_1 = zeros(1,N_subcarrier);
throughput_sc_2 = zeros(1,N_subcarrier);
throughput_sc_3 = zeros(1,N_subcarrier);
throughput_sc_4 = zeros(1,N_subcarrier);

for sc = 1:N_subcarrier
    
    % signal (real domain) table for each user
    current_signal1 = power_uuk(u1, u1, (r-1) * 12 + sc);
    current_signal2 = power_uuk(u2, u2, (r-1) * 12 + sc);
    current_signal3 = power_uuk(u3, u3, (r-1) * 12 + sc);
    current_signal4 = power_uuk(u4, u4, (r-1) * 12 + sc);
    Interference1 = power_uuk(u1, u2, (r-1) * 12 + sc) + power_uuk(u1, u3, (r-1) * 12 + sc) + power_uuk(u1, u4, (r-1) * 12 + sc);
    Interference2 = power_uuk(u2, u1, (r-1) * 12 + sc) + power_uuk(u2, u3, (r-1) * 12 + sc) + power_uuk(u2, u4, (r-1) * 12 + sc);
    Interference3 = power_uuk(u3, u1, (r-1) * 12 + sc) + power_uuk(u3, u2, (r-1) * 12 + sc) + power_uuk(u3, u4, (r-1) * 12 + sc);
    Interference4 = power_uuk(u4, u1, (r-1) * 12 + sc) + power_uuk(u4, u2, (r-1) * 12 + sc) + power_uuk(u4, u3, (r-1) * 12 + sc);
    
    %% Calculate throughput
    throughput_sc_1(sc) = log2( 1+(current_signal1)/(Interference1+10^( noise_variance_dBm / 10 )) );
    throughput_sc_2(sc) = log2( 1+(current_signal2)/(Interference2+10^( noise_variance_dBm / 10 )) );
    throughput_sc_3(sc) = log2( 1+(current_signal3)/(Interference3+10^( noise_variance_dBm / 10 )) );
    throughput_sc_4(sc) = log2( 1+(current_signal4)/(Interference4+10^( noise_variance_dBm / 10 )) );
end

end