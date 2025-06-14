function [ throughput_sc_1] = calculate_throughput_1user( power_uuk, noise_variance_dBm, r, c, combination )

N_subcarrier = 12;
throughput_sc_1 = zeros(1,N_subcarrier);

for sc = 1:N_subcarrier
    %% RR and Max-C/I
    u1 = combination(c);
    
    % signal (real domain) table for each user
    current_signal1 = power_uuk(u1, u1, (r-1) * 12 + sc);
    
    
    %% Calculate throughput
    throughput_sc_1(sc) = log2( 1+(current_signal1)/(10^( noise_variance_dBm / 10 )) );
    
end

end