function [rData] = MYbpskDem(rSig)
% BPSK������
% �����@rSig�F��M�M���i��or�s�x�N�g���j
% �߂�l�@rData�F��M�f�[�^�i��x�N�g���j
rData = ones(size(rSig));
rData(rSig<0)=0;
end
