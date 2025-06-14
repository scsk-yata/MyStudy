Ndata = 100; %�f�[�^�r�b�g��[bit]
SNRdB = 10; %SN��[dB]
Nchip = 100; %�g�U�n��[chip]
Delay = [0;10]; %�x���g�̒x����[chip]
Npath = length(Delay); %�t�F�[�W���O�o�H��
Lss = Ndata * Nchip; %�X�y�N�g���g�U�M���̒���
Nsnapshot = 100; %�X�i�b�v�V���b�g��
data =  MYrndCode([Ndata,1],0);
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol); %�V���{�����̌��o
spCode = MYrndCode([Nchip,1],1);
ssSig = spCode * bpskSymbol.';
ssSig = ssSig(:);
outputSNR_RAKE = zeros(1,Nsnapshot);
outputSNR = zeros(1,Nsnapshot);
for snpCo = 1:Nsnapshot
    ssSigMat = ssSig * ones(1,Npath);
    ssSigMatDelayed = MYdelayGen(Delay, ssSigMat);
    chCoeff = MYchCoeff(Npath,1); %�`���l���W���̐���
    chOut = ssSigMatDelayed * chCoeff;
    Pn = 10^(-SNRdB/10) * Nchip;
    rSig = chOut + MYawgn(Pn,Lss,1);
    corOut = MYcorrelator(spCode,rSig); %���֊�o�͂̌v�Z
    corOut_rshp = reshape(corOut,Nchip,Ndata);
    rakeW = zeros(Nchip,1);
    rakeW(Delay+1) = chCoeff;
    y_rake = rakeW' * corOut_rshp;
    outputSNR_RAKE(snpCo) = MYsnr(bpskSymbol, y_rake);
    w = zeros(Nchip,1);
    w(Delay(1)+1) = 1;
    y = w' * corOut_rshp;
    outputSNR(snpCo) = MYsnr(bpskSymbol, y);
end
aveOutputSNR_RAKE = MYdB(mean(outputSNR_RAKE));
aveOutputSNR = MYdB(mean(outputSNR));
disp(['*RAKE�����o�͂̕��ώ�MSN��: ',num2str(aveOutputSNR_RAKE),'[dB]'])
disp(['*�x���g���������Ȃ����̕��ώ�MSN��: ',num2str(aveOutputSNR),'[dB]'])
