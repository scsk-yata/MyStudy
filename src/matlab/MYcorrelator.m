function [corOut] = MYcorrelator(w,sig)
% ���֊�
% �����@w: �d�݌W���i������ɏd�݌W���j�Csig: ���͐M���i��x�N�g���j
% �߂�l�@corOut: ���֊�o�́i���͐M��sig�Ɠ����T�C�Y�j
sizeW = size(w);
Lw = sizeW(1); %�d�݌W���̒���
Nw = sizeW(2); %�d�݌W���̎�ށF�����̏d�݌W���ɂ�鑊�֊�o�͂𓯎��Ɍv�Z�ł��܂��B
corIn = [sig; zeros((Lw-1),1)]; %�M��������(Nw-1)��0��t��
corOut = zeros(length(sig),Nw);
for co = 1:length(corOut)
    corOut(co,:) = w' * corIn(co:(co+Lw-1));
end
end
