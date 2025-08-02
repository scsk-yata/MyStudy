Nuser = 2; %���[�U��
Nsc_per_user = 32; %���[�U������̃T�u�L��������
Nsc = Nuser * Nsc_per_user; %�S�T�u�L���������iSP�ϊ���o�́j
N_GI = 8;
NofdmSymbol = 500; %OFDM�V���{����
Ndata = Nsc_per_user * NofdmSymbol; %�f�[�^�r�b�g��[bit]
SNRdB = 20; %SN��[dB]
Lpilot = 2; %�p�C���b�g�V���{����
Delay = [0]; %�x���g�̒x����[chip]
Npath = length(Delay); %�t�F�[�W���O�o�H��
data =  MYrndCode([Ndata,Nuser],0); %�����_���f�[�^����
bpskSymbol = MYbpskMod(data); %BPSK�ϒ�
Nsymbol = length(bpskSymbol); %�V���{�����̌��o
spOut = zeros(Nsc,NofdmSymbol); %S/P�ϊ���o�͂̌v�Z
for userCo = 1:Nuser
    rangeStart = 1 + (userCo-1) * Nsc_per_user;
    rangeEnd = Nsc_per_user*userCo;
    spOut(rangeStart:rangeEnd,:) = reshape(bpskSymbol(:,userCo),Nsc_per_user,NofdmSymbol);
end
% ------------------ ���X�g7.1(sim3_ofdm.m)��13�`30�s�ڂ������� ------------------ 
pilotMat = ones(Nsc,Lpilot);%�i�C�j�p�C���b�g�V���{�����T�u�L������������������
ofdmSymbol_pilot = ifft([pilotMat,spOut]); %�i�E�j�p�C���b�g�V���{���ƂƂ���IFFT�ɓ���
gi = ofdmSymbol_pilot((end-N_GI+1):end,:); %�i�G�j�K�[�h�C���^�[�o���̍쐬
ofdmSymbol_pilot_GI = [gi;ofdmSymbol_pilot]; %�i�G�j�K�[�h�C���^�[�o����t��
sOFDM = ofdmSymbol_pilot_GI(:); %�i�I�jP/S�ϊ���
ofdmSymbolMat = sOFDM * ones(1,Npath);
ofdmSymbolMatDelayed = MYdelayGen(Delay, ofdmSymbolMat);
chOut = ofdmSymbolMatDelayed * ones(Npath,1);
Pn = 10^(-SNRdB/10) /Nsc;
rSig = chOut + MYawgn(Pn,length(chOut),1);
spOutR = reshape(rSig,(Nsc+N_GI),(Lpilot+NofdmSymbol)); %�i�J�jS/P�ϊ���
spOutR(1:N_GI,:) = []; %�i�L�j�K�[�h�C���^�[�o���iGI�j����
fftOut = fft(spOutR); %�i�N�jFFT
pilotMatRx = fftOut(:,1:Lpilot); %�i�P�j�p�C���b�g�V���{���̒��o
ofdmSymbolRx = fftOut(:,(Lpilot+1):end); %ofdm�V���{������f�[�^�̒��o
chCoeff = mean(pilotMatRx,2);
phaseShift = chCoeff./abs(chCoeff) * ones(1,NofdmSymbol); %�i�R�j�ʑ��ω��ʂ̐���
ofdmSymbolRxCompensated = ofdmSymbolRx .* conj(phaseShift);%�i�T�j�ʑ��⏞
%================================================





ofdmSymbolRx_user = zeros(Nsc,NofdmSymbol);
for userCo = 1:Nuser
    rangeStart = 1 + (userCo-1) * Nsc_per_user;
    rangeEnd = Nsc_per_user*userCo;
    ofdmSymbolRx_user = ofdmSymbolRxCompensated(rangeStart:rangeEnd,:);
    rData = MYbpskDem(MYvec(ofdmSymbolRx_user));
    BER = MYber(data(:,userCo),rData);
    disp(['* ���[�U',num2str(userCo),'��BER: ',num2str(BER)])
end
