clear

N_TP = 2;
Nu_1RB = 1;
Nu_TP1 = 8;
Nu_TP2 = 8;
Nu_all = Nu_TP1+Nu_TP2;
N_area = 24;
N_area_1TP = N_area/2;
N_subcar_1RB = 12;
N_trial = 3000;

file_name = ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'];

%load( [file_name,'/psa2a'],'PSA2A','PSA2Ac','PSA2Ap')
load( [file_name,'/psa2a_data25'],'PSA2A','PSA2Ac','PSA2Ap')

ratio_nml = zeros(N_area_1TP*2,3);
ratio_con = zeros(N_area_1TP*2,3);
ratio_pro = zeros(N_area_1TP*2,3);

for a = 1:N_area_1TP
    ratio_nml(a,:) = [1, (sum(PSA2A(a,1:N_area_1TP))-PSA2A(a,a))/PSA2A(a,a)/(N_area_1TP-1), sum(PSA2A(a,N_area_1TP+1:2*N_area_1TP))/PSA2A(a,a)/N_area_1TP];
    
end

for a = N_area_1TP+1:N_area_1TP*2
    ratio_nml(a,:) = [1, (sum(PSA2A(a,N_area_1TP+1:2*N_area_1TP))-PSA2A(a,a))/PSA2A(a,a)/(N_area_1TP-1), sum(PSA2A(a,1:N_area_1TP))/PSA2A(a,a)/N_area_1TP];
    
end


for a = 1:N_area_1TP
    ratio_con(a,:) = [1, (sum(PSA2Ac(a,1:N_area_1TP))-PSA2Ac(a,a))/PSA2Ac(a,a)/(N_area_1TP-1), sum(PSA2Ac(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ac(a,a)/N_area_1TP];
    
end

for a = N_area_1TP+1:N_area_1TP*2
    ratio_con(a,:) = [1, (sum(PSA2Ac(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ac(a,a))/PSA2Ac(a,a)/(N_area_1TP-1), sum(PSA2Ac(a,1:N_area_1TP))/PSA2Ac(a,a)/N_area_1TP];
    
end


for a = 1:N_area_1TP
    ratio_pro(a,:) = [1, (sum(PSA2Ap(a,1:N_area_1TP))-PSA2Ap(a,a))/PSA2Ap(a,a)/(N_area_1TP-1), sum(PSA2Ap(a,N_area_1TP+1:2*N_area_1TP))/PSA2Ap(a,a)/N_area_1TP];
    
end

for a = N_area_1TP+1:N_area_1TP*2
    ratio_pro(a,:) = [1, (sum(PSA2Ap(a,N_area_1TP+1:2*N_area_1TP))-PSA2Ap(a,a))/PSA2Ap(a,a)/(N_area_1TP-1), sum(PSA2Ap(a,1:N_area_1TP))/PSA2Ap(a,a)/N_area_1TP];
    
end

ratio_nml
ratio_con
ratio_pro