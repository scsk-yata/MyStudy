function [chCoeff] = MYchCoeff(N, Pa)
% �����_���`���l���W���i�U���F���C���[�C�ʑ��F��l���z�j�𐶐�����֐�
% �����@N: �`���l���W���̐��CPa: ���ϓd��
% �߂�l�@chCoeff: �`���l���W���iN�~1)
rndPhase = rand(N,1)*2*pi; 
rylAmp = MYrylrnd(Pa, N);
chCoeff = rylAmp.*exp(1j*rndPhase);
end
