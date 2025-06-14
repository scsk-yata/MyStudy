DOAdeg = 30; %��ɗ���M�������p�x[�x]
DOAdeg_delayed = -10; %�x���g�̐M�������p�x[�x]
Delay = [0,1]; %�e�M���̒x����
Nsignal = length(Delay); %�M����
Ndata = 1000; %�f�[�^�r�b�g��[bit]
SNRdB = 10; %�A���e�i1�{�������SN��[dB]
N_R = 4; %��M�A���e�i�{��
d = .5; %�g���Ő��K�������A���e�i�Ԋu
data = MYrndCode([Ndata,1],0);
bpskSymbol = MYbpskMod(data);
Nsymbol = length(bpskSymbol);%�V���{�����̌��o
bpskSymbols = bpskSymbol * ones(1,Nsignal); %�V���{���̃R�s�[
bpskSymbols = MYdelayGen(Delay, bpskSymbols);
Pn = 10^(-SNRdB/10);
steers = MYsteer(N_R,d,[DOAdeg,DOAdeg_delayed]);
rSig = steers * bpskSymbols.' + MYawgn(Pn,N_R,Nsymbol);
Rxx = rSig * rSig'; 
gamma_rx = rSig * conj(bpskSymbol(:,1));
w = inv(Rxx) * gamma_rx; 
y_wi = w'* rSig; % Wiener�����d�݌W���ɂ����Ƃ��̃A���e�i�o��
outputSNR_wi = MYsnr(bpskSymbol, y_wi); % ���̏o��SN��
y = ones(1,N_R) * rSig; % �A���e�i��M�M�������������������Ƃ��̃A���e�i�o��
outputSNR = MYsnr(bpskSymbol, y); % ���̏o��SN��
disp(['* Wiener�����g�����Ƃ��̎�MSN��: ',num2str(MYdB(outputSNR_wi)),'[dB]'])
disp(['* �A���e�i��M�M�������̂܂ܑ����������̎�MSN��:',num2str(MYdB(outputSNR)),'[dB]'])
[doa,antPat_dB_wi] = MYantPattern(N_R,w,d); %�A���e�i�p�^�[���̌v�Z
[doa,antPat_dB] = MYantPattern(N_R,ones(4,1),d); %�A���e�i�p�^�[���̌v�Z
figure; plot(doa,antPat_dB_wi,doa,antPat_dB); axis([-90 90 -30 0]) %�A���e�i�p�^�[���̕`��