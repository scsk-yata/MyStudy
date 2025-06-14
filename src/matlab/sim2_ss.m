%% 
Ndata = 10; 
SNRdB = 20; 
Nchip = 100; % �g�U�n��[chip]
Lss = Ndata * Nchip; % �X�y�N�g���g�U�M���̒���[chip]
Delay = [0;10]; % �I�𐫃t�F�[�W���O�Ő�����x����[chip]
Npath = length(Delay); % �o�H���FDelay�̗v�f�����o�H���Ƃ���B
data =  MYrndCode([Ndata,1],0); 
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol);
spCode = MYrndCode([Nchip,1],1); %�g�U�n��Ƃ��Ďg��2�l(-1,1)�����_���n�񐶐�
ssSig = spCode * bpskSymbol.';
ssSig = ssSig(:); 
ssSigMat = ssSig * ones(1,Npath);
ssSigMatDelayed = MYdelayGen(Delay, ssSigMat);
chOut = ssSigMatDelayed * ones(Npath,1);
Pn = 10^(-SNRdB/10) * Nchip;
rSig = chOut + MYawgn(Pn,Lss,1);
corOut = MYcorrelator(spCode,rSig); %���֊�o�͂̌v�Z
figure; plot(real(corOut))
corOut_rshp = reshape(corOut,Nchip,Ndata);%�s�[�N�_�̒��o�i�}7-17�Q�Ɓj
rData = MYbpskDem(corOut_rshp(1,:));
BER = MYber(data,rData.')
