function [rndCode] = MYrndCode(codeSize,Type)
% [0,1]�܂���[1,-1]�̃����_���n��𐶐�
% �����@codeSize: �������郉���_���n��̃T�C�Y[�s���~��]
% �@�@�@Type: �^�C�v(0or1)   0:[0,1], 1:[-1,1]
% �߂�l�@rndCode: �����_���n��i��x�N�g���j
rndCode = randn(codeSize);
rndCode(rndCode>0) = 1;
if Type == 0
    rndCode(rndCode<=0) = 0;
else
    rndCode(rndCode<=0) = -1;
end
end
