Ndata = 1000; %�f�[�^�r�b�g��[bit]
Nchip = 100; %�g�U�n��[chip]
UserPower = [1,100]; %�[�����Ƃ̓d�́F���ߖ�������
Nuser = length(UserPower); %���[�U�[���i���M�@�̐��j�̌��o
SNRdB = 20; %��P���[�U�i���M�@�j�̓d��UserPower(1)�ɑ΂���SN��[dB]
Lss = Ndata * Nchip; %�X�y�N�g���g�U�M���̒���
data =  MYrndCode([Ndata,Nuser],0); %�f�[�^�n��̐���
bpskSymbol = MYbpskMod(data); %BPSK�ϒ�
Nsymbol = length(bpskSymbol); %�V���{�����̌��o
spCode = MYrndCode([Nchip,Nuser],1); %�g�U�n��̔���
ssSig = spCode * diag(sqrt(UserPower)) * bpskSymbol.'; %�X�y�N�g���g�U�M���̔���
ssSig = ssSig(:); %��x�N�g����
Pn = 10^(-SNRdB/10) * sqrt(UserPower(1)) * Nchip;
rSig = ssSig + MYawgn(Pn,Lss,1);
corOut = MYcorrelator(spCode,rSig);
for userCo = 1:Nuser
    corOut_rshp = reshape(corOut(:,userCo),Nchip,Ndata);
    rData = MYbpskDem(corOut_rshp(1,:));
    BER = MYber(data(:,userCo),rData.');
    disp(['* �[��',num2str(userCo),'��BER�F',num2str(BER)])
end
