function [ throughput_sc_1, throughput_sc_2] = calculate_throughput_PF( power_matrix, noise_variance_dBm, rb, UE_comb, combination )


N_subcarrier = 12;
throughput_sc_1 = zeros(1,N_subcarrier);
throughput_sc_2 = zeros(1,N_subcarrier);

for sc = 1:N_subcarrier

    u1 = combination(UE_comb, 1);
    u2 = combination(UE_comb, 2);

    % signal (real domain) table for each user
    current_signal_u1 = power_matrix(u1, u1, (rb-1) * 12 + sc);
    current_signal_u2 = power_matrix(u2, u2, (rb-1) * 12 + sc);
    Interference_u1_u2 = power_matrix(u1, u2, (rb-1) * 12 + sc);
    Interference_u2_u1 = power_matrix(u2, u1, (rb-1) * 12 + sc);

    %% Calculate throughput
    throughput_sc_1(sc) = log2( 1+(current_signal_u1)/(Interference_u1_u2+10^( noise_variance_dBm / 10 )) );
    throughput_sc_2(sc) = log2( 1+(current_signal_u2)/(Interference_u2_u1+10^( noise_variance_dBm / 10 )) );

end

end