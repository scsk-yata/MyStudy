Ndata = 1000; %�f�[�^�r�b�g��[bit]
SNRdB = 10; %�A���e�i�P�{������̕���SN��[dB]
N_R = 4; %��M�A���e�i�{��
Nsnapshot = 100; %�X�i�b�v�V���b�g��
data = MYrndCode([Ndata,1],0);
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol);
outputSNR_MRC = zeros(1,Nsnapshot);
outputSNR = zeros(1,Nsnapshot);
for snpCo = 1:Nsnapshot
    Pn = 10^(-SNRdB/10);
    chCoeff = MYchCoeff(N_R,1); %�`���l���W���̔���
    rSig = chCoeff * bpskSymbol.' + MYawgn(Pn,N_R,Nsymbol);
    y_MRC = chCoeff' * rSig; %�ő�䍇�����s�����o��
    outputSNR_MRC(snpCo) = MYsnr(bpskSymbol, y_MRC);
    y = ones(1,N_R) * rSig; %�P���ɃA���e�i��M�M���𑫂����o��
    outputSNR(snpCo) = MYsnr(bpskSymbol, y);
end
aveOutputSNR_MRC = MYdB(mean(outputSNR_MRC));
aveOutputSNR = MYdB(mean(outputSNR));
disp(['* MRC�����̕��ώ�MSN��: ',num2str(aveOutputSNR_MRC),'[dB]'])
disp(['* �A���e�i��M�M����P���ɂ��������̕��ώ�MSN��: ',num2str(aveOutputSNR),'[dB]'])
