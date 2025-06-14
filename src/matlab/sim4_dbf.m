%%
Ndata = 1000; %�f�[�^�r�b�g��[bit]
SNRdB = 10; %�A���e�i�P�{�������SN��[dB]
N_R = 4; %��M�A���e�i�{��
d = .5; %�g���Ő��K�������A���e�i�Ԋu
DOAdeg = 30; %�M�������p�x[�x]
pointingDOAdeg = 15; %��M�A���e�i�̎w�����̕����@�d�g�̓��������ƈقȂ�
data = MYrndCode([Ndata,1],0); bpskSymbol = MYbpskMod(data); %�����_���f�[�^������BPSK�ϒ�
Nsymbol = length(bpskSymbol);%�V���{�����̌��o
Pn = 10^(-SNRdB/10); %�G���d�͂̌v�Z
steer1 = MYsteer(N_R,d,DOAdeg);%�M���X�e�A�����O�x�N�g���̌v�Z
rSig = steer1 * bpskSymbol.'+ MYawgn(Pn,N_R,Nsymbol); %��M�M���̌v�Z�i���i38�j�Q�Ɓj
y1 = steer1' * rSig; %��M�M���̃X�e�A�����O�x�N�g�����d�݌W���Ƃ��Ďg�����Ƃ��̏o�͌v�Z
outputSNR1 = MYsnr(bpskSymbol, y1); %���̎��̏o��SNR�̌v�Z
steer2 = MYsteer(N_R,d,pointingDOAdeg); %pointingDOAdeg�Őݒ肵�������Ɏw������������X�e�A�����O�x�N�g��
y2 = steer2' * rSig; %���̎��̎�M�M���̌v�Z
outputSNR2 = MYsnr(bpskSymbol, y2); %���̎��̏o��SN��̌v�Z
disp(['* �w������M�����������i',num2str(DOAdeg),'�x�j�Ɍ������Ƃ��̎�MSN��:',num2str(MYdB(outputSNR1)),'[dB]'])
disp(['* �w�������قȂ�����i',num2str(pointingDOAdeg),'�x�j�Ɍ������Ƃ��̎�MSN��:',num2str(MYdB(outputSNR2)),'[dB]'])
[doa1,antPat_dB1] = MYantPattern(N_R,steer1,d); %steer1���g������M�A���e�i�̎w�����̌v�Z
[doa2,antPat_dB2] = MYantPattern(N_R,steer2,d); %steer2���g������M�A���e�i�̎w�����̌v�Z
figure; plot(doa1,antPat_dB1,doa2,antPat_dB2); axis([-90 90 -30 0]) %�w�����̕`��
