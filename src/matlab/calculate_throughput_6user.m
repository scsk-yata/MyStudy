function [ throughput_sc_1, throughput_sc_2, throughput_sc_3, throughput_sc_4, throughput_sc_5, throughput_sc_6] = calculate_throughput_6user( power_uuk, noise_variance_dBm, r, c, combination )

N_subcarrier = 12;
throughput_sc_1 = zeros(1,N_subcarrier);
throughput_sc_2 = zeros(1,N_subcarrier);
throughput_sc_3 = zeros(1,N_subcarrier);
throughput_sc_4 = zeros(1,N_subcarrier);
throughput_sc_5 = zeros(1,N_subcarrier);
throughput_sc_6 = zeros(1,N_subcarrier);

for sc = 1:N_subcarrier
    %% RR and Max-C/I
    u1 = combination(c, 1);
    u2 = combination(c, 2);
    u3 = combination(c, 3);
    u4 = combination(c, 4);
    u5 = combination(c, 5);
    u6 = combination(c, 6);
    % signal (real domain) table for each user
    current_signal1 = power_uuk(u1, u1, (r-1) * 12 + sc);
    current_signal2 = power_uuk(u2, u2, (r-1) * 12 + sc);
    current_signal3 = power_uuk(u3, u3, (r-1) * 12 + sc);
    current_signal4 = power_uuk(u4, u4, (r-1) * 12 + sc);
    current_signal5 = power_uuk(u5, u5, (r-1) * 12 + sc);
    current_signal6 = power_uuk(u6, u6, (r-1) * 12 + sc);
    
    Interference1 = power_uuk(u1, u2, (r-1) * 12 + sc) + power_uuk(u1, u3, (r-1) * 12 + sc) + power_uuk(u1, u4, (r-1) * 12 + sc) + power_uuk(u1, u5, (r-1) * 12 + sc) + power_uuk(u1, u6, (r-1) * 12 + sc);
    Interference2 = power_uuk(u2, u1, (r-1) * 12 + sc) + power_uuk(u2, u3, (r-1) * 12 + sc) + power_uuk(u2, u4, (r-1) * 12 + sc) + power_uuk(u2, u5, (r-1) * 12 + sc) + power_uuk(u2, u6, (r-1) * 12 + sc);
    Interference3 = power_uuk(u3, u1, (r-1) * 12 + sc) + power_uuk(u3, u2, (r-1) * 12 + sc) + power_uuk(u3, u4, (r-1) * 12 + sc) + power_uuk(u3, u5, (r-1) * 12 + sc) + power_uuk(u3, u6, (r-1) * 12 + sc);
    Interference4 = power_uuk(u4, u1, (r-1) * 12 + sc) + power_uuk(u4, u2, (r-1) * 12 + sc) + power_uuk(u4, u3, (r-1) * 12 + sc) + power_uuk(u4, u5, (r-1) * 12 + sc) + power_uuk(u4, u6, (r-1) * 12 + sc);
    Interference5 = power_uuk(u5, u1, (r-1) * 12 + sc) + power_uuk(u5, u2, (r-1) * 12 + sc) + power_uuk(u5, u3, (r-1) * 12 + sc) + power_uuk(u5, u4, (r-1) * 12 + sc) + power_uuk(u5, u6, (r-1) * 12 + sc);
    Interference6 = power_uuk(u6, u1, (r-1) * 12 + sc) + power_uuk(u6, u2, (r-1) * 12 + sc) + power_uuk(u6, u3, (r-1) * 12 + sc) + power_uuk(u6, u4, (r-1) * 12 + sc) + power_uuk(u6, u5, (r-1) * 12 + sc);
    
    %% Calculate throughput
    throughput_sc_1(sc) = log2( 1+(current_signal1)/(Interference1+10^( noise_variance_dBm / 10 )) );
    throughput_sc_2(sc) = log2( 1+(current_signal2)/(Interference2+10^( noise_variance_dBm / 10 )) );
    throughput_sc_3(sc) = log2( 1+(current_signal3)/(Interference3+10^( noise_variance_dBm / 10 )) );
    throughput_sc_4(sc) = log2( 1+(current_signal4)/(Interference4+10^( noise_variance_dBm / 10 )) );
    throughput_sc_5(sc) = log2( 1+(current_signal5)/(Interference5+10^( noise_variance_dBm / 10 )) );
    throughput_sc_6(sc) = log2( 1+(current_signal6)/(Interference6+10^( noise_variance_dBm / 10 )) );
end

end