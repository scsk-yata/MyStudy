%% ユーザの分布，チャネル応答のデータを予め作成
clear
clc
rng('shuffle');

N_trial = 10000;

N_TP = 2;
d_TP = 200;
d_edge = d_TP/2;

Nu_TP1 = 16;
Nu_TP2 = 16;

N_ver = 8;
N_hor = 16;

N_subcar = 288;

H_1uak = ones(Nu_TP1+Nu_TP2,N_hor*N_ver,N_subcar);
H_2uak = ones(Nu_TP1+Nu_TP2,N_hor*N_ver,N_subcar);
PL_dB_tu = zeros(N_TP,Nu_TP1+Nu_TP2);

%%
for n = 1:N_trial
    
d_tu = zeros(N_TP,Nu_TP1+Nu_TP2);
hor_tu = zeros(N_TP,Nu_TP1+Nu_TP2);

%
for u = 1:Nu_TP1
    hor_tu(1,u) = 180*rand;
    if (hor_tu(1,u) <= 45) || (135 <= hor_tu(1,u))
        d_tu(1,u) = d_edge*rand/abs(cosd(hor_tu(1,u)));
    else
        d_tu(1,u) = d_edge*rand/abs(cosd(90-hor_tu(1,u)));
    end
    
    d_tu(2,u) = sqrt( d_tu(1,u)^2 + d_TP^2 - 2*d_tu(1,u)*d_TP*cosd(180-hor_tu(1,u)) );
    hor_tu(2,u) = asind( d_tu(1,u)*sind(180-hor_tu(1,u))/d_tu(2,u) );
    
    [PL_dB_1u,H_ak_1u] = PL_dB_H_ak_CDL(d_tu(1,u),hor_tu(1,u));
    [PL_dB_2u,H_ak_2u] = PL_dB_H_ak_CDL(d_tu(2,u),hor_tu(2,u));
    %[PL_dB_1u,H_ak_1u] = PL_dB_H_ak_CDLOS(d_tu(1,u),hor_tu(1,u));
    %[PL_dB_2u,H_ak_2u] = PL_dB_H_ak_CDLOS(d_tu(2,u),hor_tu(2,u));
    PL_dB_tu(1,u) = PL_dB_1u;
    PL_dB_tu(2,u) = PL_dB_2u;
    for k = 1:N_subcar
        for a = 1:N_hor*N_ver
    H_1uak(u,a,k) = H_ak_1u(a,k);
    H_2uak(u,a,k) = H_ak_2u(a,k);
        end
    end
end

for u = Nu_TP1+1:(Nu_TP1+Nu_TP2)
    hor_tu(2,u) = 180*rand;
    if (hor_tu(2,u) <= 45) || (135 <= hor_tu(2,u))
        d_tu(2,u) = d_edge*rand/abs(cosd(hor_tu(2,u)));
    else
        d_tu(2,u) = d_edge*rand/abs(cosd(90-hor_tu(2,u)));
    end
    
    d_tu(1,u) = sqrt( d_tu(2,u)^2 + d_TP^2 - 2*d_tu(2,u)*d_TP*cosd(hor_tu(2,u)) );
    hor_tu(1,u) = 180 - asind( d_tu(2,u)*sind(hor_tu(2,u))/d_tu(1,u) );
    
    [PL_dB_1u,H_ak_1u] = PL_dB_H_ak_CDL(d_tu(1,u),hor_tu(1,u));
    [PL_dB_2u,H_ak_2u] = PL_dB_H_ak_CDL(d_tu(2,u),hor_tu(2,u));
    %[PL_dB_1u,H_ak_1u] = PL_dB_H_ak_CDLOS(d_tu(1,u),hor_tu(1,u));
    %[PL_dB_2u,H_ak_2u] = PL_dB_H_ak_CDLOS(d_tu(2,u),hor_tu(2,u));
    PL_dB_tu(1,u) = PL_dB_1u;
    PL_dB_tu(2,u) = PL_dB_2u;
    for k = 1:N_subcar
        for a = 1:N_hor*N_ver
    H_1uak(u,a,k) = H_ak_1u(a,k);
    H_2uak(u,a,k) = H_ak_2u(a,k);
        end
    end
end
%}

hor_tu(hor_tu==0) = 0.000000001;

save(['User_Distribution_Channel/Distribution_Channel_',num2str(n),'trial.mat'] ,'d_tu','hor_tu','PL_dB_tu','H_1uak','H_2uak')

end