function [sigMat] = MYdelayGen(delayVec, sigMat)
% ���͂��ꂽ�M��������̎����C�x��������֐�
% �����@delayVec�F�x���ʁi��or�s�x�N�g���j�CsigMat:�x��������M���i������Ɏ��ԁj
% �@�@�@��delayVec�̗v�f����sigMat�̗񐔂���v����K�v����B
%      ���擪��delayVec��0��}�����Ēx�������B
% �߂�l�@sigMat:�x���������M���i������Ɏ��ԁj
Nsig = length(delayVec); %�x��������M����
if Nsig~=length(sigMat(1,:))
    error('Error: MYdelayGen(): delayVec�̗v�f����sigMat�̗񐔂���v���܂���B')
end
for co = 1:Nsig
    if delayVec(co)>0
        sigMat(delayVec(co)+1:end,co) = sigMat(1:(end-delayVec(co)),co);
        sigMat(1:(delayVec(co)),co) = zeros((delayVec(co)),1);
    end
end
end
