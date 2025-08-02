%% 
clear

N_TP = 2;
Nu_1RB = 2;
Nu_TP1 = 8;
Nu_TP2 = 8;
Nu_all = Nu_TP1+Nu_TP2;
N_area = 32;
N_area_1TP = N_area/2;
N_subcar_1RB = 12;
N_trial = 3000;
%
area_boundary = [0,atand(4/N_area_1TP),atand(2*4/N_area_1TP),atand(3*4/N_area_1TP),45,90-atand(3*4/N_area_1TP),90-atand(2*4/N_area_1TP),90-atand(4/N_area_1TP),90 ...
    ,90+atand(4/N_area_1TP),90+atand(2*4/N_area_1TP),90+atand(3*4/N_area_1TP),135,180-atand(3*4/N_area_1TP),180-atand(2*4/N_area_1TP),180-atand(4/N_area_1TP),180];
%{
area_boundary = [0,atand(4/N_area_1TP),atand(2*4/N_area_1TP),45,90-atand(2*4/N_area_1TP),90-atand(4/N_area_1TP)...
    ,90,90+atand(4/N_area_1TP),90+atand(2*4/N_area_1TP),135,180-atand(2*4/N_area_1TP),180-atand(4/N_area_1TP),180];
%
area_boundary = [0,atand(4/N_area_1TP),45,90-atand(4/N_area_1TP),90,90+atand(4/N_area_1TP),135,180-atand(4/N_area_1TP),180];
%
area_boundary = [0,45,90,135,180];
%}

file_name = ['Result_',num2str(N_area),'_',num2str(Nu_TP1),num2str(Nu_TP2),'_',num2str(Nu_1RB),'_',num2str(N_trial),'trial_CDL-D'];

PSA2A = zeros(N_area,N_area);
PSA2Ac = zeros(N_area,N_area);
PSA2Ap = zeros(N_area,N_area);

total_nua = 0;
total_mua = 0;

%%
for trial = 1:N_trial
%load( [file_name,'/Data5_',num2str(trial),'trial'] )
load( [file_name,'/All_Data_',num2str(trial),'trial'] )

a2aps = zeros(N_area,N_area);
a2apsc = zeros(N_area,N_area);
a2apsp = zeros(N_area,N_area);

nua = zeros(1,Nu_all);
mua1 = zeros(1,Nu_TP1);
mua2 = zeros(1,Nu_TP2);
count_nua = 0;
count_mua1 = 0;
count_mua2 = 0;

hor_tu(hor_tu==0) = 0.000000001;
hor_1all = hor_tu(1,1:Nu_TP1);
hor_2all = hor_tu(2,Nu_TP1+1:Nu_all);

% 基地局1についてエリアカウント
for ai = 1:N_area_1TP
    au = find( ( area_boundary(ai) < hor_1all ) & ( hor_1all <= area_boundary(ai+1) ) );
    
    if isempty(au)
        count_nua = count_nua + 1;
        nua(count_nua) = ai;
        
    elseif length(au) == 1
        
    else
        count_mua1 = count_mua1 + 1;
        mua1(count_mua1) = ai;
        
    end
end

% 基地局２についてエリアカウント
for ai = N_area_1TP+1:N_area
    au = find( ( area_boundary(ai-N_area_1TP) < hor_2all ) & ( hor_2all <= area_boundary(ai-N_area_1TP+1) ) );
    
    if isempty(au)
        count_nua = count_nua + 1;
        nua(count_nua) = ai;
        
    elseif length(au) == 1
        
    else
        count_mua2 = count_mua2 + 1;
        mua2(count_mua2) = ai;
        
    end
end

nua(nua == 0) = [];
mua1(mua1 == 0) = [];
mua2(mua2 == 0) = [];

total_nua = length(nua)+total_nua/N_trial;
total_mua = length(mua1)+length(mua2)+total_mua/N_trial;

%
if length(mua1) < 2
    mua1 = 1:N_area_1TP;
    mua1(ismember(mua1,nua)) = [];
end

if length(mua2) < 2
    mua2 = N_area_1TP+1:N_area;
    mua2(ismember(mua2,nua)) = [];
end
%}




%% 比較手法
for f = 1:length(c1rf(1,:))
    for r = 1:24
        for k = 1:12
            
            for i1 = 1:2
                for i2 = 1:2
a2aps(u2a(UC1(c1rf(r,f),i1)),u2a(UC1(c1rf(r,f),i2))) = a2aps(u2a(UC1(c1rf(r,f),i1)),u2a(UC1(c1rf(r,f),i2))) + power_uuk_all(UC1(c1rf(r,f),i1),UC1(c1rf(r,f),i2),N_subcar_1RB*(r-1)+k);
a2aps(u2a(UC1(c1rf(r,f),i1)),u2a(UC2(c2rf(r,f),i2))) = a2aps(u2a(UC1(c1rf(r,f),i1)),u2a(UC2(c2rf(r,f),i2))) + power_uuk_all(UC1(c1rf(r,f),i1),UC2(c2rf(r,f),i2),N_subcar_1RB*(r-1)+k);
a2aps(u2a(UC2(c2rf(r,f),i1)),u2a(UC1(c1rf(r,f),i2))) = a2aps(u2a(UC2(c2rf(r,f),i1)),u2a(UC1(c1rf(r,f),i2))) + power_uuk_all(UC2(c2rf(r,f),i1),UC1(c1rf(r,f),i2),N_subcar_1RB*(r-1)+k);
a2aps(u2a(UC2(c2rf(r,f),i1)),u2a(UC2(c2rf(r,f),i2))) = a2aps(u2a(UC2(c2rf(r,f),i1)),u2a(UC2(c2rf(r,f),i2))) + power_uuk_all(UC2(c2rf(r,f),i1),UC2(c2rf(r,f),i2),N_subcar_1RB*(r-1)+k);
                end
            end
            
        end
    end
end



%% 従来手法
for f = 1:2:length(c1rf(1,:))-1
    for r = 1:24
    
        if nnz(area_user(N_area*3/4+1:N_area,:)) > 1
            for k = 1:12
                
                for i1 = 1:2
                    for i2 = 1:2
a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) = a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) + power_uuk_all(UC1(c1rfco(r,f),i1),UC1(c1rfco(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC2co(c2rfco(r,f),i2))) = a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC2co(c2rfco(r,f),i2))) + power_uuk_all(UC1(c1rfco(r,f),i1),UC2co(c2rfco(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2co(c2rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) = a2apsc(u2a(UC2co(c2rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) + power_uuk_all(UC2co(c2rfco(r,f),i1),UC1(c1rfco(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2co(c2rfco(r,f),i1)),u2a(UC2co(c2rfco(r,f),i2))) = a2apsc(u2a(UC2co(c2rfco(r,f),i1)),u2a(UC2co(c2rfco(r,f),i2))) + power_uuk_all(UC2co(c2rfco(r,f),i1),UC2co(c2rfco(r,f),i2),N_subcar_1RB*(r-1)+k);
                    end
                end
                
            end


        elseif nnz(area_user(N_area*3/4+1:N_area,:)) == 1
            aur = area_user(N_area*3/4+1:N_area,1);
            for k = 1:12

                for i1 = 1:2
                    for i2 = 1:2
a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) = a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) + power_uuk_all(UC1(c1rfco(r,f),i1),UC1(c1rfco(r,f),i2),N_subcar_1RB*(r-1)+k);
                    end
a2apsc(u2a(aur(aur~=0)),u2a(UC1(c1rfco(r,f),i1))) = a2apsc(u2a(aur(aur~=0)),u2a(UC1(c1rfco(r,f),i1))) + power_uuk_all(aur(aur~=0),UC1(c1rfco(r,f),i1),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(aur(aur~=0))) = a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(aur(aur~=0))) + power_uuk_all(UC1(c1rfco(r,f),i1),aur(aur~=0),N_subcar_1RB*(r-1)+k);
                end
a2apsc(u2a(aur(aur~=0)),u2a(aur(aur~=0))) = a2apsc(u2a(aur(aur~=0)),u2a(aur(aur~=0))) + power_uuk_all(aur(aur~=0),aur(aur~=0),N_subcar_1RB*(r-1)+k);

            end

        
        else
            for k = 1:12
                for i1 = 1:2
                    for i2 = 1:2
a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) = a2apsc(u2a(UC1(c1rfco(r,f),i1)),u2a(UC1(c1rfco(r,f),i2))) + power_uuk_all(UC1(c1rfco(r,f),i1),UC1(c1rfco(r,f),i2),N_subcar_1RB*(r-1)+k);
                    end
                end
            end
          
        end
        
    end
end





%% 
for f = 2:2:length(c1rf(1,:))
    for r = 1:24
        
        if nnz(area_user(1:N_area*1/4,:)) > 1
            for k = 1:12
                for i1 = 1:2
                    for i2 = 1:2
a2apsc(u2a(UC1ce(c1rfce(r,f),i1)),u2a(UC1ce(c1rfce(r,f),i2))) = a2apsc(u2a(UC1ce(c1rfce(r,f),i1)),u2a(UC1ce(c1rfce(r,f),i2))) + power_uuk_all(UC1ce(c1rfce(r,f),i1),UC1ce(c1rfce(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC1ce(c1rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) = a2apsc(u2a(UC1ce(c1rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) + power_uuk_all(UC1ce(c1rfce(r,f),i1),UC2(c2rfce(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC1ce(c1rfce(r,f),i2))) = a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC1ce(c1rfce(r,f),i2))) + power_uuk_all(UC2(c2rfce(r,f),i1),UC1ce(c1rfce(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) = a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) + power_uuk_all(UC2(c2rfce(r,f),i1),UC2(c2rfce(r,f),i2),N_subcar_1RB*(r-1)+k);
                    end
                end
            end
        
            
        elseif nnz(area_user(1:N_area*1/4,:)) == 1
            aul = area_user(1:N_area*1/4,:);
            
            for k = 1:12
                
                for i1 = 1:2
                    for i2 = 1:2
a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) = a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) + power_uuk_all(UC2(c2rfce(r,f),i1),UC2(c2rfce(r,f),i2),N_subcar_1RB*(r-1)+k);
                    end
a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(aul(aul~=0))) = a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(aul(aul~=0))) + power_uuk_all(UC2(c2rfce(r,f),i1),aul(aul~=0),N_subcar_1RB*(r-1)+k);
a2apsc(u2a(aul(aul~=0)),u2a(UC2(c2rfce(r,f),i1))) = a2apsc(u2a(aul(aul~=0)),u2a(UC2(c2rfce(r,f),i1))) + power_uuk_all(aul(aul~=0),UC2(c2rfce(r,f),i1),N_subcar_1RB*(r-1)+k);
                end
a2apsc(u2a(aul(aul~=0)),u2a(aul(aul~=0))) = a2apsc(u2a(aul(aul~=0)),u2a(aul(aul~=0))) + power_uuk_all(aul(aul~=0),aul(aul~=0),N_subcar_1RB*(r-1)+k);

            end


        
        else
            for k = 1:12
                for i1 = 1:2
                    for i2 = 1:2
a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) = a2apsc(u2a(UC2(c2rfce(r,f),i1)),u2a(UC2(c2rfce(r,f),i2))) + power_uuk_all(UC2(c2rfce(r,f),i1),UC2(c2rfce(r,f),i2),N_subcar_1RB*(r-1)+k);
                    end
                end
            end
           
        end
        
    end
end







%% 提案手法

for f = 1:length(c1rf(1,:))
    for r = 1:24
        
    
        area1 = AC1(carf1(r,f),1);
        nnz1 = nnz(area_user(area1,:));
        
        if nnz1 == 0
            [~,mi] = min(abs( mua1-area1 ));
            area1 = mua1(mi);
            nnz1 = nnz( area_user(area1,:) );
        end
        
        area2 = AC1(carf1(r,f),2);
        
        if area1 ~= area2
            nnz2 = nnz( area_user(area2,:) );
        else
            [~,mi] = mink(abs( mua1-area2 ),2);
            area2 = mua1(mi(2));
            nnz2 = nnz( area_user(area2,:) );
        end
        
        if nnz2 == 0
            [~,mi] = min(abs( mua1-area2 ));
            area2 = mua1(mi);
            if area1 ~= area2
            nnz2 = nnz( area_user(area2,:) );
            else
            [~,mi] = mink(abs( mua1-area2 ),2);
            area2 = mua1(mi(2));
            nnz2 = nnz( area_user(area2,:) );
            end
        
        end
        
    
    
    % 提案手法のためのユーザ分け
user1rfp = [area_user(area1,1:nnz1),area_user(area2,1:nnz2)];
user1rfp = sort(user1rfp);

if isempty(user1rfp)
    UC1rfp = [];
else
    UC1rfp = combnk(user1rfp,Nu_1RB);
end

        area3 = AC2(carf2(r,f),1);
        nnz3 = nnz(area_user(area3,:));
        
        if nnz3 == 0
            [~,mi] = min(abs( mua2-area3 ));
            area3 = mua2(mi);
            nnz3 = nnz( area_user(area3,:) );
        end
        
        area4 = AC2(carf2(r,f),2);
        
        if area3 ~= area4
            nnz4 = nnz( area_user(area4,:) );
        else
            [~,mi] = mink(abs( mua2-area4 ),2);
            area4 = mua2(mi(2));
            nnz4 = nnz( area_user(area4,:) );
        end
        
        if nnz4 == 0
            [~,mi] = min(abs( mua2-area4 ));
            area4 = mua2(mi);
            if area3 ~= area4
            nnz4 = nnz( area_user(area4,:) );
            else
            [~,mi] = mink(abs( mua2-area4 ),2);
            area4 = mua2(mi(2));
            nnz4 = nnz( area_user(area4,:) );
            end
        
        end
        
            
% 提案手法のためのユーザ分け
user2rfp = [area_user(area3,1:nnz3),area_user(area4,1:nnz4)];
user2rfp = sort(user2rfp);

if isempty(user2rfp)
    UC2rfp = [];
else
    UC2rfp = combnk(user2rfp,Nu_1RB);
end



        %% 実際の値
        for k = 1:12
            for i1 = 1:2
                for i2 = 1:2
a2apsp(u2a(UC1rfp(c1rfp(r,f),i1)),u2a(UC1rfp(c1rfp(r,f),i2))) = a2apsp(u2a(UC1rfp(c1rfp(r,f),i1)),u2a(UC1rfp(c1rfp(r,f),i2))) + power_uuk_all(UC1rfp(c1rfp(r,f),i1),UC1rfp(c1rfp(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsp(u2a(UC1rfp(c1rfp(r,f),i1)),u2a(UC2rfp(c2rfp(r,f),i2))) = a2apsp(u2a(UC1rfp(c1rfp(r,f),i1)),u2a(UC2rfp(c2rfp(r,f),i2))) + power_uuk_all(UC1rfp(c1rfp(r,f),i1),UC2rfp(c2rfp(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsp(u2a(UC2rfp(c2rfp(r,f),i1)),u2a(UC1rfp(c1rfp(r,f),i2))) = a2apsp(u2a(UC2rfp(c2rfp(r,f),i1)),u2a(UC1rfp(c1rfp(r,f),i2))) + power_uuk_all(UC2rfp(c2rfp(r,f),i1),UC1rfp(c1rfp(r,f),i2),N_subcar_1RB*(r-1)+k);
a2apsp(u2a(UC2rfp(c2rfp(r,f),i1)),u2a(UC2rfp(c2rfp(r,f),i2))) = a2apsp(u2a(UC2rfp(c2rfp(r,f),i1)),u2a(UC2rfp(c2rfp(r,f),i2))) + power_uuk_all(UC2rfp(c2rfp(r,f),i1),UC2rfp(c2rfp(r,f),i2),N_subcar_1RB*(r-1)+k);
                end
            end
        end

    end
end

%{
for a = 1:N_area
    a2apst(a,:,trial) = a2aps(a,:);
    a2apstc(a,:,trial) = a2aps(a,:);
    a2apstp(a,:,trial) = a2aps(a,:);
end
%}

PSA2A = PSA2A + a2aps/N_trial;
PSA2Ac = PSA2Ac + a2apsc/N_trial;
PSA2Ap = PSA2Ap + a2apsp/N_trial;

%%

%{
save( [file_name,'/All_Data_',num2str(trial),'trial'],'AC1','AC12','AC2','area_user','c1rf','c1rfce','c1rfco','c1rfp','c2rf','c2rfce','c2rfco','c2rfp'...
    ,'carf1','carf2','cumulative_throughput','cumulative_throughput_con','cumulative_throughput_pro','d_tu','hor_tu','N_aut','P_tul','PL_dB_tu','power_uuk_all','total_comb','total_comb_con','total_comb_pro'...
    ,'u2a','UC1','UC12','UC1ce','UC2','UC2co')
%}
end

%{
for a = 1:N_area
    PSA2A(a,:)/PSA2A(a,a)
end
%}
%save( [file_name,'/psa2a'],'PSA2A','PSA2Ac','PSA2Ap')
save( [file_name,'/psa2a_All_data'],'PSA2A','PSA2Ac','PSA2Ap','total_mua','total_nua')