N_T = 2; %���M�A���e�i��
N_R = 2; %��M�A���e�i��
Ndata = 1000; %�f�[�^��
SNRdB = 100; %[dB] ����SN��i�����Ƃ������p�C�v�Œ�`�j
data = MYrndCode([N_T, Ndata],0); %���M�f�[�^����
bpskSymbols = MYbpskMod(data); %BPSK�ϒ�
H = MYawgn(1,N_R,N_T); %�`���l���W���s��̔���
[V_R,LambdaM,V_T] = svd(H); %���ْl����
U = V_T * bpskSymbols; %���M�d�݌W���̂����Z
Pn = 10^(-SNRdB/10) * LambdaM(1); %�G���d�͂̌v�Z�i�p�C�v1�Œ�`����悤�Ɂj
X = H * U + MYawgn(Pn,N_R,Ndata); %��M�M���̌v�Z
Y = V_R' * X; %��M�d�݌W���̏�Z
rData = MYbpskDem(Y); %����
for pipeCo = 1:N_R
    BER = MYber(data(pipeCo,:),rData(pipeCo,:));
    disp(['* �p�C�v#',num2str(pipeCo),'��BER�F',num2str(BER)])
end
